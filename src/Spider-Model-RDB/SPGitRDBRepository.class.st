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

{ #category : #storing }
SPGitRDBRepository >> deleteCommit: aCommit from: aRepo [

	| allRefs children |
	
	allRefs := self getRefsToCommit: aCommit.
	allRefs do: [ :eachRef |
		(aRepo commitRefs includes: eachRef)
			ifTrue: [ self deleteRepoRefs: (Array with: eachRef) from: aRepo ] ].
		
	children := self selectChildrenOf: aCommit id.
	children do: [ :eachChildCommit |
		self deleteCommit: eachChildCommit from: aRepo ].
	
	self deleteGitCommitParentRefQuery execute: aCommit id.
	self deleteGitCommitQuery execute: aCommit id
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> deleteGitCommitParentRefQuery [

	| sql |
	
	sql := 'DELETE FROM git_commit_parent_refs WHERE commit_id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> deleteGitCommitQuery [

	| sql |
	
	sql := 'DELETE FROM git_commits WHERE id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> deleteGitRepoRefQuery [

	| sql |
	
	sql := 'DELETE FROM git_repo_refs WHERE repo_id = $1 AND type = $2 AND name = $3'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #storing }
SPGitRDBRepository >> deleteRepoRefs: aRefColl from: aRepo [

	| repoId rows |
	
	repoId := aRepo id ifNil: [ (self storeRepo: aRepo) id ].

	rows := aRefColl collect: [ :each |
		Array with: repoId with: each type with: each name ].
	
	self deleteGitRepoRefQuery executeBatch: rows.
]

{ #category : #queries }
SPGitRDBRepository >> getCommitById: anId ifAbsent: aBlock [

	| gitCommit |
	
	gitCommit := self glorpSession readOneOf: SPGitCommit where: [ :e | e id = anId ].
	^ gitCommit isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ gitCommit ]
]

{ #category : #queries }
SPGitRDBRepository >> getCommitByShaString: aString ifAbsent: aBlock [

	| gitCommit |

	aString size = 40
		ifTrue: [ 
			gitCommit := self glorpSession readOneOf: SPGitCommit where: [ :e | e shaString = aString ] ]
		ifFalse: [ 
			| list |
			list := self glorpSession read: SPGitCommit 
				where: [ :e | e shaString like: (aString, '%') ] 
				limit: 2.
			list size > 1
				ifTrue: [ self error: 'SHA string fragment not unique' ].
			gitCommit := list isEmpty ifTrue: [ nil ] ifFalse: [ list first ] ].
		
	^ gitCommit 
			ifNotNil: [ gitCommit ]
			ifNil: aBlock
]

{ #category : #queries }
SPGitRDBRepository >> getGitCommitIdByShaString: aString [

	| q |
	
	q := (Query readOneOf: SPGitCommit where: [ :e | e shaString = aString ])
		retrieve: [ :e | e id ];
		yourself.
	^ self glorpSession execute: q
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

{ #category : #queries }
SPGitRDBRepository >> getRefsToCommit: aCommit [

	| q |
	
	q := Query read: SPGitRepoToCommitRef where: [ :e | e commit = aCommit ].
	q alsoFetch: [ :e | e  ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPGitRDBRepository >> getRepo: aDomain owner: anOwner name: aName ifAbsent: aBlock [

	| searchUrl query repo |
	
	searchUrl := SPGitRepo searchUrlFor: aDomain owner: anOwner name: aName.
	query := Query readOneOf: SPGitRepo 
			where: [ :e | e url asLowercase like: searchUrl asLowercase ].
	query shouldRefresh: true.
	repo := self glorpSession execute: query.
	^ repo isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ repo ]
]

{ #category : #queries }
SPGitRDBRepository >> getRepoCommits: aRepo limit: aLimit [

	| repoIds query |
	
	repoIds := Array with: aRepo id.
	query := Query read: SPGitCommit where: [ :e | e repos anySatisfy: [ :r | r in: repoIds ] ].
	query orderBy: [ :e | e authorSignature datetime desc ].
	query limit: aLimit.
	
	^self glorpSession execute: query
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
SPGitRDBRepository >> includesCommitWithShaString: aString [

	^ (self getGitCommitIdByShaString: aString) notNil
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
	
	sql := 'INSERT INTO git_commits (txid, sha, author_datetime, author_tzoffset, author_name, author_email, message, status, source_dir, format)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10) RETURNING (id)'.

	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitRepoCommitQuery [

	| sql |
	
	sql := 'INSERT INTO git_repo_commits (repo_id, commit_id, txid) VALUES ($1,$2,$3) ON CONFLICT DO NOTHING'.
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
	
	sql := 'INSERT INTO git_repo_refs (repo_id, type, name, txid, commit_id) VALUES ($1,$2,$3,$4,$5)
ON CONFLICT (repo_id, type, name) DO UPDATE SET
	txid = $4,
	commit_id = $5'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #accessing }
SPGitRDBRepository >> packageIdOf: aPackage [

	^ aPackage id isNil
			ifTrue: [ self packageRepo storePackage: aPackage ]
			ifFalse: [ aPackage id ]
]

{ #category : #queries }
SPGitRDBRepository >> selectAllChildrenOf: aCommitId [
	"A recursive query to retrieve all child commits of <aCommitId>."

	| sql query |
	
	sql := 'WITH RECURSIVE all_children AS (
	SELECT commit_id AS id FROM git_commit_parent_refs WHERE parent_id = {1}
	UNION
	SELECT gcpr.commit_id FROM git_commit_parent_refs gcpr, all_children ap WHERE ap.id = gcpr.parent_id)
SELECT DISTINCT 
	t1.ID, t1.TXID, t1.SHA, t1.AUTHOR_DATETIME, t1.AUTHOR_TZOFFSET, t1.AUTHOR_NAME, t1.AUTHOR_EMAIL, t1.MESSAGE, t1.STATUS, t1.SOURCE_DIR, t1.FORMAT 
FROM git_commits t1 
WHERE t1.id in (select id from all_children) order by t1.id desc' format: (Array with: aCommitId).
	
	query := Query read: SPGitCommit.
	query sql: sql.
	
	^ query executeWithParameters: (Array with: aCommitId) in: self glorpSession
]

{ #category : #queries }
SPGitRDBRepository >> selectAllParentsOf: aCommitId [
	"A recursive query to retrieve all parent commits of <aCommitId>."

	| sql query |
	
	sql := 'WITH RECURSIVE all_parents AS (
	SELECT parent_id AS id FROM git_commit_parent_refs WHERE commit_id = {1}
	UNION
	SELECT gcpr.parent_id FROM git_commit_parent_refs gcpr, all_parents ap WHERE ap.id = gcpr.commit_id)
SELECT DISTINCT 
	t1.ID, t1.TXID, t1.SHA, t1.AUTHOR_DATETIME, t1.AUTHOR_TZOFFSET, t1.AUTHOR_NAME, t1.AUTHOR_EMAIL, t1.MESSAGE, t1.STATUS, t1.SOURCE_DIR, t1.FORMAT 
FROM git_commits t1 
WHERE t1.id in (select id from all_parents) order by t1.id desc' format: (Array with: aCommitId).
	
	query := Query read: SPGitCommit.
	query sql: sql.
	
	^ query executeWithParameters: (Array with: aCommitId) in: self glorpSession
]

{ #category : #queries }
SPGitRDBRepository >> selectChildrenOf: aCommitId [

	^ self glorpSession read: SPGitCommit 
			where: [ :e | e parents anySatisfy: [ :p | p id = aCommitId ] ]
]

{ #category : #queries }
SPGitRDBRepository >> selectRepoRefsOf: aRepoId [

	| q |
	
	q := Query read: SPGitRepoToCommitRef where: [ :e | e repo id = aRepoId ].
	^ self glorpSession execute: q
]

{ #category : #queries }
SPGitRDBRepository >> selectRepoRefsOfCommit: aCommitId [

	| q |
	
	q := Query read: SPGitRepoToCommitRef where: [ :e | e commit id = aCommitId ].
	^ self glorpSession execute: q
]

{ #category : #queries }
SPGitRDBRepository >> selectReposByUrl [

	^ self selectReposByUrl: 0 limit: 100
]

{ #category : #queries }
SPGitRDBRepository >> selectReposByUrl: anOffset limit: aLimit [

	| q |
	
	q := Query read: SPGitRepo.
	q orderBy: [ :e | e url ].
	q offset: anOffset.
	q limit: aLimit.
	
	^ self glorpSession execute: q
]

{ #category : #queries }
SPGitRDBRepository >> selectReposByUrlWithDomain: aDomain offset: anOffset limit: aLimit [

	| prefix q |
	
	prefix := (SPGitRepo searchUrlForDomain: aDomain), '%'.
	q := Query read: SPGitRepo where: [ :e | e url asLowercase like: prefix asLowercase ].
	q orderBy: [ :e | e url ].
	q offset: anOffset.
	q limit: aLimit.
	
	^ self glorpSession execute: q
]

{ #category : #queries }
SPGitRDBRepository >> selectReposByUrlWithDomain: aDomain owner: anOwner offset: anOffset limit: aLimit [

	| prefix q |
	
	prefix := (SPGitRepo searchUrlForDomain: aDomain owner: anOwner), '%'.
	q := Query read: SPGitRepo where: [ :e | e url asLowercase like: prefix asLowercase ].
	q orderBy: [ :e | e url ].
	q offset: anOffset.
	q limit: aLimit.
	
	^ self glorpSession execute: q
]

{ #category : #storing }
SPGitRDBRepository >> storeCommit: aGitCommit [

	| gitCommit gitCommitId rows |
	
	gitCommit := self getCommitByShaString: aGitCommit shaString ifAbsent: [ nil ].
	gitCommit notNil
		ifTrue: [ ^ gitCommit id ].
		
	gitCommitId := self insertGitCommitQuery getOne: (
		OrderedCollection new
			add: self transactionId;
			add: aGitCommit shaString;
			add: aGitCommit datetime;
			add: aGitCommit authorSignature tzOffset;
			add: aGitCommit authorSignature name;
			add: aGitCommit authorSignature email;
			add: aGitCommit message;
			add: aGitCommit status;
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
SPGitRDBRepository >> storeCommit: aGitCommit for: aRepo [

	| gitCommitId gitRepoId |
	
	gitCommitId := aGitCommit id ifNil: [ self storeCommit: aGitCommit ].
	gitRepoId := aRepo id ifNil: [ (self storeRepo: aRepo) id ].
	self insertGitRepoCommitQuery execute: (Array with: gitRepoId with: gitCommitId with: self transactionId)
]

{ #category : #storing }
SPGitRDBRepository >> storeRepo: aGitRepo [

	| gitRepo |
	
	gitRepo := self getGitRepoByUrl: aGitRepo url ifAbsent: [ nil ].
	gitRepo isNil
		ifFalse: [ ^ gitRepo ].

	self insertGitRepoQuery getOne: (Array 
		with: self transactionId
		with: aGitRepo url).
		
	^ self getGitRepoByUrl: aGitRepo url ifAbsent: [ nil ]
]

{ #category : #storing }
SPGitRDBRepository >> storeRepoRef: aRepo type: aTypeChar named: aName to: aCommit [

	| repoId commitId |
	
	repoId := aRepo id ifNil: [ (self storeRepo: aRepo) id ].
	commitId := aCommit id ifNil: [ self getGitCommitIdByShaString: aCommit shaString ].
	
	self insertGitRepoRefQuery execute: (Array
		with: repoId
		with: aTypeChar
		with: aName
		with: self transactionId
		with: commitId)
]
