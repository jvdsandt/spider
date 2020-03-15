Class {
	#name : #SPGitRDBRepository,
	#superclass : #SPGitRepository,
	#instVars : [
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #internal }
SPGitRDBRepository >> commitWithAllChildrenCTE [
	"Answer a String with a SQL recursive Common Table Expression (CTE) with the id of a commit
	and all its children/descendants commit id's."

	^ 'WITH RECURSIVE all_children AS (
	SELECT commit_id AS id FROM git_commit_parent_refs WHERE commit_id = {1}
	UNION
	SELECT gcpr.commit_id FROM git_commit_parent_refs gcpr, all_children ap WHERE ap.id = gcpr.parent_id)
'
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
SPGitRDBRepository >> getAuthorsOfPackageNamed: aName [

	| q |
	
	q := Query read: SPGitCommit 
		where: [ :e | e packages anySatisfy: [ :p | p name = aName ] ].
	q retrieve: [ :e | e authorSignature name distinct ].
	q retrieve: [ :e | e authorSignature email ].
	q orderBy: [ :e | e authorSignature name ].

	^ (self glorpSession execute: q) collect: [ :each |
			SPGitAuthor name: each first email: each last ]
]

{ #category : #'queries-commits' }
SPGitRDBRepository >> getCommitById: anId ifAbsent: aBlock [

	| gitCommit |
	
	gitCommit := self glorpSession readOneOf: SPGitCommit where: [ :e | e id = anId ].
	^ gitCommit isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ gitCommit ]
]

{ #category : #'queries-commits' }
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

{ #category : #'queries-commits' }
SPGitRDBRepository >> getCommitIdByShaString: aString [

	| q |
	
	q := (Query readOneOf: SPGitCommit where: [ :e | e shaString = aString ])
		retrieve: [ :e | e id ];
		yourself.
	^ self glorpSession execute: q
]

{ #category : #'queries-commits' }
SPGitRDBRepository >> getCommitsImportedAfter: aDateAndTime [

	| q |
	
	q := (Query read: SPGitCommit where: [ :e | e transaction startedAt >= aDateAndTime ])
		orderBy: [ :e | e transaction startedAt descending ];
		yourself.

	^ self glorpSession execute: q
]

{ #category : #'queries-commits' }
SPGitRDBRepository >> getCommitsWithRootId: anInteger after: aDateTime [ 

	| q |
	
	q := Query read: SPGitCommit 
		where: [ :e | e rootId = anInteger AND: [ e authorSignature datetime > aDateTime ] ].
	q orderBy: [ :e | e authorSignature datetime descending ].

	^ self glorpSession execute: q
]

{ #category : #'queries-commits' }
SPGitRDBRepository >> getLatestCommits: aCount [

	| q |
	
	q := (Query read: SPGitCommit)
		orderBy: [ :e | e authorSignature datetime descending ];
		limit: aCount;
		yourself.

	^ self glorpSession execute: q
]

{ #category : #'queries-refs' }
SPGitRDBRepository >> getLatestRepoRefs: aCount [
	"Answer a collection of GitRepoToCommitRef instances with the most recent commit per repository."
	"Note that currently the result can contain more than one item per repository if multiple branches
	point to the same commit. Can be fixed using 'DISTINCT ON (..)' but I don't know how to do this in Glorp."

	| q |
	
	q := Query read: SPGitRepoToCommitRef
		where: [ :e | 
			| maxQuery |
			maxQuery := Query read: SPGitRepoToCommitRef
				where: [ :me | me type = 'B' AND: [ me repo = e repo ] ].
			maxQuery retrieve: [ :me | me commit authorSignature datetime max ].
			e type = 'B' AND: [ e commit authorSignature datetime = maxQuery ] ].
	q alsoFetch: [ :e | e repo ].
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime descending ].
	q limit: aCount.
	
	^ self glorpSession execute: q
]

{ #category : #'queries-commits' }
SPGitRDBRepository >> getNewestCommitWithPackageNamed: aName [

	| q list |
	
	q := Query read: SPGitCommit 
		where: [ :e | e packages anySatisfy: [ :p | p name = aName ] ].
	q orderBy: [ :e | e authorSignature datetime descending ].
	q limit: 1.

	list := self glorpSession execute: q.
	^ list notEmpty
			ifTrue: [ list first ]
			ifFalse: [ nil ]
]

{ #category : #'queries-commits' }
SPGitRDBRepository >> getOldestCommitWithClass: aClassId [

	| q list |
	
	q := Query read: SPGitCommit where: [ :e | e packages 
		anySatisfy: [ :p | p classRefs anySatisfy: [ :r | r spiderClass id = aClassId ] ] ].

	q orderBy: [ :e | e authorSignature datetime ].
	q limit: 1.

	list := self glorpSession execute: q.
	^ list notEmpty
			ifTrue: [ list first ]
			ifFalse: [ nil ]
]

{ #category : #'queries-commits' }
SPGitRDBRepository >> getOldestCommitWithPackage: aPackageId [

	| q list |
	
	q := Query read: SPGitCommit where: [ :e | e packages anySatisfy: [ :p | p id = aPackageId ] ].
	q orderBy: [ :e | e authorSignature datetime ].
	q limit: 1.

	list := self glorpSession execute: q.
	^ list notEmpty
			ifTrue: [ list first ]
			ifFalse: [ nil ]
]

{ #category : #'queries-commits' }
SPGitRDBRepository >> getOldestCommitWithPackageNamed: aName [

	| q list |
	
	q := Query read: SPGitCommit 
		where: [ :e | e packages anySatisfy: [ :p | p name = aName ] ].
	q orderBy: [ :e | e authorSignature datetime ].
	q limit: 1.

	list := self glorpSession execute: q.
	^ list notEmpty
			ifTrue: [ list first ]
			ifFalse: [ nil ]
]

{ #category : #'queries-refs' }
SPGitRDBRepository >> getRefsToCommit: aCommit [

	| q |
	
	q := Query read: SPGitRepoToCommitRef where: [ :e | e commit = aCommit ].
	q alsoFetch: [ :e | e  ].

	^ self glorpSession execute: q
]

{ #category : #'queries-refs' }
SPGitRDBRepository >> getRefsToCommitOrChild: aCommitId [ 
	"Answer a collection "

	| sql query |
	
	sql := self commitWithAllChildrenCTE, 'SELECT DISTINCT 
	t1.REPO_ID, t1.TYPE, t1.NAME, t1.TXID, t1.COMMIT_ID
FROM git_repo_refs t1
WHERE t1.COMMIT_ID in (select id from all_children) order by t1.COMMIT_ID desc' format: (Array with: aCommitId).
	
	query := Query read: SPGitRepoToCommitRef.
	query sql: sql.
	
	^ self glorpSession execute: query
]

{ #category : #'queries-repos' }
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

{ #category : #'queries-repos' }
SPGitRDBRepository >> getRepoByUrl: anUrl ifAbsent: aBlock [

	| gitRepo |
	
	gitRepo := self glorpSession readOneOf: SPGitRepo 
		where: [ :e | e url asLowercase = anUrl asLowercase ].
		
	^ gitRepo isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ gitRepo ]
]

{ #category : #'queries-refs' }
SPGitRDBRepository >> getRepoRefsFrom: aRepoId toCommit: aCommitId [

	| q |
	
	q := Query read: SPGitRepoToCommitRef
		where: [ :e | e repo id = aRepoId AND: [ e commit id = aCommitId ] ].
	
	^ self glorpSession execute: q
]

{ #category : #'queries-repos' }
SPGitRDBRepository >> getRepos: aStringSearchCriteria max: aLimit [

	| q |
	
	q := Query read: SPGitRepo where: aStringSearchCriteria asWhereUrlBlock.
	q orderBy: [ :e | e url ].
	q limit: aLimit.
	
	^ self glorpSession execute: q
]

{ #category : #'queries-repos' }
SPGitRDBRepository >> getReposReferencingCommitOrChild: aCommitId [

	| sql query |
	
	sql := self commitWithAllChildrenCTE, 'SELECT DISTINCT t1.ID, t1.TXID, t1.URL, t1.FORKED_FROM
FROM git_repos t1
WHERE t1.ID IN (SELECT REPO_ID FROM git_repo_refs WHERE COMMIT_ID in (select id from all_children)) order by t1.ID desc' format: (Array with: aCommitId).
	
	query := Query read: SPGitRepo.
	query sql: sql.
	
	^ self glorpSession execute: query
]

{ #category : #'queries-repos' }
SPGitRDBRepository >> getReposWithCommitSha: aString [

	| repoIds q |
	
	repoIds := self selectReposWithCommitShaQuery query: (Array with: aString).
	
	q := Query read: SPGitRepo 
		where: [ :e | e id in: repoIds ].
	^ self glorpSession execute: q
]

{ #category : #'queries-repos' }
SPGitRDBRepository >> getReposWithPackageNamed: aName [

	| q |
	
	q := Query read: SPGitRepo 
		where: [ :e | e commitRefs anySatisfy: [ :ref | 
				ref commit packages anySatisfy: [ :p |
					p name = aName ] ] ].
	
	^ self glorpSession execute: q
]

{ #category : #'queries-repos' }
SPGitRDBRepository >> getReposWithRootId: aRootId [

	| q |
	
	q := Query read: SPGitRepo 
		where: [ :e | e commitRefs anySatisfy: [ :ref | ref commit rootId = aRootId ] ].
	
	^ self glorpSession execute: q
]

{ #category : #storing }
SPGitRDBRepository >> getRootIdForCommit: aGitCommit [
	"Determine the rootId for <aGitCommit>.
	- If all parents have the same rootId, than use this value
	- If there are no parents or no parents with a rootId
		- return and create a new rootId if this commit contains any code
		- answer nil if this commit does not contain any code
	- If there are parents with different rootId's than merge these"

	| parentIds |

	aGitCommit rootId notNil
		ifTrue: [ ^ aGitCommit rootId ].
		
	parentIds := ((aGitCommit parents collect: #rootId) reject: #isNil) asSet.
	parentIds size = 1
		ifTrue: [ ^ parentIds anyOne ].
		
	parentIds isEmpty
		ifTrue: [ 
			^ aGitCommit hasPackages 
				ifTrue: [ self storeCommitRoot: aGitCommit shaString ]
				ifFalse: [ nil ] ].

	^ self mergeCommitRoots: parentIds
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

{ #category : #testing }
SPGitRDBRepository >> includesCommitWithShaString: aString [

	^ (self getCommitIdByShaString: aString) notNil
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
	
	sql := 'INSERT INTO git_commits (txid, sha, author_datetime, author_tzoffset, author_name, author_email, message, status, root_id, source_dir, format)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11) RETURNING (id)'.

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

{ #category : #storing }
SPGitRDBRepository >> mergeCommitRoots: aRootIdsInput [

	| rootIds statement result shas |

	rootIds := aRootIdsInput sorted.
	rootIds allButFirstDo: [ :eachId |
		
		statement := self p3client format: 'SELECT root_shas FROM git_commit_roots WHERE id = $1'.
		result := statement query: (Array with: eachId).
		shas := result firstRecord first.
	
		statement := self p3client format: 'UPDATE git_commit_roots SET root_shas = root_shas || $2 WHERE id = $1'.
		statement execute: (Array with: rootIds first with: (self stringArrayAsPostgres: shas)).
		
		statement := self p3client format: 'UPDATE git_commits SET root_id = $2 WHERE root_id = $1'.
		statement execute: (Array with: eachId with: rootIds first).
		
		statement := self p3client format: 'DELETE FROM git_commit_roots WHERE id = $1'.
		statement execute: (Array with: eachId) ].
	^ rootIds first
]

{ #category : #accessing }
SPGitRDBRepository >> p3client [

	^ context client
]

{ #category : #accessing }
SPGitRDBRepository >> packageIdOf: aPackage [

	^ aPackage id isNil
			ifTrue: [ self packageRepo storePackage: aPackage ]
			ifFalse: [ aPackage id ]
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
SPGitRDBRepository >> selectReposByCommitRootId: aRootId [

	| q |
	
	q := Query read: SPGitRepo where: [ :e | e commitRefs anySatisfy: [ :ref | ref commit rootId = aRootId ] ].
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

{ #category : #'accessing - queries' }
SPGitRDBRepository >> selectReposWithCommitShaQuery [

	| sql |
	
	sql := 
		self withRecursiveAllChildCommitsBySha, 
		'SELECT DISTINCT repo_id FROM git_repo_refs grr WHERE grr.commit_id in (SELECT id from with_all_children)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #storing }
SPGitRDBRepository >> storeCommit: aGitCommit [

	| gitCommit gitCommitId rows rootId |
	
	gitCommit := self getCommitByShaString: aGitCommit shaString ifAbsent: [ nil ].
	gitCommit notNil
		ifTrue: [ ^ gitCommit id ].
		
	rootId := self getRootIdForCommit: aGitCommit.
	aGitCommit privRootId: rootId.

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
			add: rootId;
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

	aGitCommit id ifNil: [ self storeCommit: aGitCommit ].
	aRepo id ifNil: [ (self storeRepo: aRepo) id ]
]

{ #category : #storing }
SPGitRDBRepository >> storeCommitRoot: aShaString [

	| statement result |
	
	statement := self p3client format: 'INSERT INTO git_commit_roots (txid, root_shas) VALUES ($1, $2) RETURNING (id)'.
	result := statement query: (Array with: self transactionId with: (self stringArrayAsPostgres: (Array with: aShaString))).
	^ result firstRecord first
]

{ #category : #storing }
SPGitRDBRepository >> storeRepo: aGitRepo [

	| gitRepo |
	
	gitRepo := self getRepoByUrl: aGitRepo url ifAbsent: [ nil ].
	gitRepo isNil
		ifFalse: [ ^ gitRepo ].

	self insertGitRepoQuery getOne: (Array 
		with: self transactionId
		with: aGitRepo url).
		
	^ self getRepoByUrl: aGitRepo url ifAbsent: [ nil ]
]

{ #category : #storing }
SPGitRDBRepository >> storeRepoRef: aRepo type: aTypeChar named: aName to: aCommit [

	| repoId commitId |
	
	repoId := aRepo id ifNil: [ (self storeRepo: aRepo) id ].
	commitId := aCommit id ifNil: [ self getCommitIdByShaString: aCommit shaString ].
	
	self insertGitRepoRefQuery execute: (Array
		with: repoId
		with: aTypeChar
		with: aName
		with: self transactionId
		with: commitId)
]

{ #category : #storing }
SPGitRDBRepository >> stringArrayAsPostgres: anArray [

	^ String streamContents: [ :s |
			s nextPut: ${.
			anArray
				do: [ :each | s nextPut: $"; nextPutAll: each; nextPut: $" ]
				separatedBy: [ s nextPut: $, ].
			s nextPut: $} ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> withRecursiveAllChildCommitsBySha [
	"Answer a Common Table Expression (CTE) with the id's of a commit and all its children."

	^'WITH RECURSIVE with_all_children AS (
	SELECT id FROM git_commits WHERE sha = $1
	UNION
	SELECT gcpr.commit_id 
	FROM git_commit_parent_refs gcpr, with_all_children ap 
	WHERE ap.id = gcpr.parent_id)
'
]
