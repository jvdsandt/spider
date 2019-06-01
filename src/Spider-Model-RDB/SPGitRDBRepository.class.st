Class {
	#name : #SPGitRDBRepository,
	#superclass : #SPGitRepository,
	#instVars : [
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #internal }
SPGitRDBRepository >> createGitRepoFrom: anArray [
	"(id, txid, root_id, url, forked_from_id)"

	self todo
]

{ #category : #queries }
SPGitRDBRepository >> getCommitBySha: aBytes ifAbsent: aBlock [

	| gitCommit |
	
	gitCommit := self glorpSession readOneOf: SPGitCommit where: [ :e | e sha = aBytes ].
	^ gitCommit isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ gitCommit ]
]

{ #category : #queries }
SPGitRDBRepository >> getGitCommitIdBySha: aBytes [

	| q |
	
	q := (Query readOneOf: SPGitCommit where: [ :e | e sha = aBytes ])
		retrieve: [ :e | e id ];
		yourself.
	^ self glorpSession execute: q
]

{ #category : #storing }
SPGitRDBRepository >> getGitRepoByUrl: aRepoUrl [

	| gitRepo gitRepoId |
	
	gitRepo := self getGitRepoByUrl: aRepoUrl ifAbsent: [ nil ].
	gitRepo isNil
		ifFalse: [ ^ gitRepo ].

	gitRepoId := self insertGitRepoQuery getOne: (Array 
		with: self transactionId
		with: aRepoUrl).
		
	^ SPGitRepo url: aRepoUrl
]

{ #category : #queries }
SPGitRDBRepository >> getGitRepoByUrl: anUrl ifAbsent: aBlock [

	| gitRepo |
	
	gitRepo := self glorpSession readOneOf: SPGitRepo 
		where: [ :e | e url asLowercase = anUrl asLowercase ].
		
	^ gitRepo isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ gitRepo ]
]

{ #category : #accessing }
SPGitRDBRepository >> gitCommitIdOf: aGitCommit [

	^ aGitCommit id isNil
			ifTrue: [ self storeCommit: aGitCommit ]
			ifFalse: [ aGitCommit id ]
]

{ #category : #accessing }
SPGitRDBRepository >> glorpSession [

	^ context glorpSession
]

{ #category : #queries }
SPGitRDBRepository >> includesCommitWithSha: aBytes [

	^ (self getGitCommitIdBySha: aBytes) notNil
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitCommitPackageRefQuery [

	| sql |
	
	sql := 'INSERT INTO git_commit_pack_refs (commit_id, package_id) VALUES ($1,$2)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitCommitParentRefQuery [

	| sql |
	
	sql := 'INSERT INTO git_commit_parent_refs (commit_id, parent_id, seqnr) VALUES ($1,$2,$3)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitCommitQuery [

	| sql |
	
	sql := 'INSERT INTO git_commits (txid, sha, author_datetime, author_tzoffset, author_name, author_email, message, source_dir, format)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING (id)'.

	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitRepoQuery [

	| sql |
	
	sql := 'INSERT INTO git_repos (txid, url) VALUES ($1,$2) RETURNING (id)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitRepoRefQuery [

	| sql |
	
	sql := 'INSERT INTO git_repo_refs (repo_id, name, txid, commit_id) VALUES ($1,$2,$3,$4)
ON CONFLICT (repo_id, name) DO UPDATE SET
	txid = $3,
	commit_id = $4'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #accessing }
SPGitRDBRepository >> packageIdOf: aPackage [

	^ aPackage id isNil
			ifTrue: [ self packageRepo storePackage: aPackage ]
			ifFalse: [ aPackage id ]
]

{ #category : #storing }
SPGitRDBRepository >> storeCommit: aGitCommit [

	| gitCommit gitCommitId rows |
	
	gitCommit := self getCommitBySha: aGitCommit sha ifAbsent: [ nil ].
	gitCommit notNil
		ifTrue: [ ^ gitCommit id ].
		
	gitCommitId := self insertGitCommitQuery getOne: (
		OrderedCollection new
			add: self transactionId;
			add: aGitCommit sha;
			add: aGitCommit datetime;
			add: aGitCommit authorSignature tzOffset;
			add: aGitCommit authorSignature name;
			add: aGitCommit authorSignature email;
			add: aGitCommit message;
			add: aGitCommit sourceDir;
			add: aGitCommit format;
			yourself ).
			
	rows := aGitCommit packages collect: [ :eachPackage |
		| packageId |
		packageId := self packageIdOf: eachPackage.		
		Array with: gitCommitId with: packageId ].
	self insertGitCommitPackageRefQuery executeBatch: rows.	

	rows := OrderedCollection new: aGitCommit parents size.
	aGitCommit parents doWithIndex: [ :eachParent :index |
		| parentId |
		parentId := self gitCommitIdOf: eachParent.
		rows add: (Array with: gitCommitId with: parentId with: index) ].
	self insertGitCommitParentRefQuery executeBatch: rows.
	
	^ gitCommitId
]

{ #category : #storing }
SPGitRDBRepository >> storeCommit: aGitCommit repo: aRepoUrl [

	| gitRepo |
	
	gitRepo := self getGitRepoByUrl: aRepoUrl ifAbsent: [ nil ].
	gitRepo isNil
		ifTrue: [ 
			 ]
]

{ #category : #storing }
SPGitRDBRepository >> storeRepoRef: aRepo named: aName to: aCommit [

	| repoId commitId |
	
	repoId := aRepo id ifNil: [ self getGitRepoByUrl: aRepo url ].
	commitId := aCommit id ifNil: [ self getGitCommitIdBySha: aCommit sha ].
	
	self insertGitRepoRefQuery execute: (Array
		with: repoId
		with: aName
		with: self transactionId
		with: commitId)
]
