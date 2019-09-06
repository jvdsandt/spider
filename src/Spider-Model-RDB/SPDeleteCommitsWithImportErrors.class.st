Class {
	#name : #SPDeleteCommitsWithImportErrors,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #'as yet unclassified' }
SPDeleteCommitsWithImportErrors >> deleteCommit: aCommit [
	"Delete <aCommit> and all commits that are based on it (all its children recursively)"

	| statement |

	aCommit children do: [ :each |
		self deleteCommit: each ].
	
	statement := self p3client format: 'DELETE FROM git_repo_refs WHERE commit_id = $1'.
	statement execute: (Array with: aCommit id).
	
	statement := self p3client format: 'DELETE FROM git_repo_commits WHERE commit_id = $1'.
	statement execute: (Array with: aCommit id).

	statement := self p3client format: 'DELETE FROM git_commit_pack_refs WHERE commit_id = $1'.
	statement execute: (Array with: aCommit id).

	statement := self p3client format: 'DELETE FROM git_commits WHERE id = $1'.
	statement execute: (Array with: aCommit id).
	
]

{ #category : #examples }
SPDeleteCommitsWithImportErrors >> exampleDeleteIcebergErrors [
	"self new context: SPWebContext default context; exampleDeleteIcebergErrors"

	| repo dt |
	
	repo := self gitRepo getGitRepoByUrl: 'https://github.com/pharo-vcs/iceberg.git'
		ifAbsent: [ self error: 'Repo not found' ].
		
	dt := DateAndTime fromUnixTime: 0.
	
	self executeForRepo: repo after: dt
]

{ #category : #examples }
SPDeleteCommitsWithImportErrors >> exampleDeleteMooseErrors [

	| repo dt |
	
	repo := self gitRepo getGitRepoByUrl: 'https://github.com/moosetechnology/Moose.git'
		ifAbsent: [ self error: 'Repo not found' ].
		
	dt := DateAndTime fromUnixTime: 0.
	
	self executeForRepo: repo after: dt
]

{ #category : #'as yet unclassified' }
SPDeleteCommitsWithImportErrors >> executeForRepo: aRepo after: aDateTime [

	aRepo commitRefs do: [ :each |
		self executeForRepoRef: each after: aDateTime ]
]

{ #category : #'as yet unclassified' }
SPDeleteCommitsWithImportErrors >> executeForRepoRef: aRepoToCommitRef after: aDateTime [

	| commits errorCommits |
	
	commits := aRepoToCommitRef commit withAllParentsAfter: aDateTime.

	errorCommits := commits select: [ :each | each isImportError ].
	errorCommits := errorCommits sorted: [ :a :b | a datetime > b datetime ].
	
	errorCommits do: [ :each | self deleteCommit: each ]
	
]
