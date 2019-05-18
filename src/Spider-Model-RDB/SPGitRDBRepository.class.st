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
SPGitRDBRepository >> getGitRepoByUrl: anUrl ifAbsent: aBlock [

	^ self selectGitRepoByUrlQuery getOne: anUrl asLowercase ifNone: aBlock
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitBranchQuery [

	| sql |
	
	sql := 'INSERT INTO git_branch (repo_id, name, head_id) VALUES ($1,$2,$3)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitCommitPackageRefQuery [

	| sql |
	
	sql := 'INSERT INTO git_commit_pack_ref (commit_id, package_id) VALUES ($1,$2)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitCommitParentRefQuery [

	| sql |
	
	sql := 'INSERT INTO git_commit_parent_refs (commit_id, parent_id, seq_nr) VALUES ($1,$2,$3)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitCommitQuery [

	| sql |
	
	sql := 'INSERT INTO git_repo (txid, repo_root_id, sha, datetime, author_name, author_email, message)
VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING (id)'.

	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> insertGitRepoQuery [

	| sql |
	
	sql := 'INSERT INTO git_repo (txid, root_id, url, forked_from_id) VALUES ($1,$2,$3,$4) RETURNING (id)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPGitRDBRepository >> selectGitRepoByUrlQuery [

	| sql |
	
	sql := 'SELECT FROM git_repo (id, txid, root_id, url, forked_from_id) WHERE lower(url) = $1'.
	^ queries at: sql ifAbsentPut: [ 
			queries createSelect: sql output: [ :row | self createGitRepoFrom: row ] ]
]

{ #category : #storing }
SPGitRDBRepository >> storeCommit: aGitCommit repo: aRepoUrl [

	| gitRepo |
	
	gitRepo := self getGitRepoByUrl: aRepoUrl ifAbsent: [ nil ].
	gitRepo isNil
		ifTrue: [ 
			 ]
]
