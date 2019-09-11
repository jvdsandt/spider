Class {
	#name : #SPDeleteCommitsWithImportErrors,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Batch'
}

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
	"SPWebContext default do: [ self new exampleDeleteMooseErrors ]"

	| repo dt |
	
	repo := self gitRepo getGitRepoByUrl: 'https://github.com/moosetechnology/Moose.git'
		ifAbsent: [ self error: 'Repo not found' ].
		
	dt := DateAndTime fromUnixTime: 0.
	
	self executeForRepo: repo after: dt
]

{ #category : #'as yet unclassified' }
SPDeleteCommitsWithImportErrors >> executeForRepo: aRepo after: aDateTime [

"	aRepo commitRefs do: [ :each |
		self executeForRepoRef: each after: aDateTime ]"
	
	self executeForRepoDirect: aRepo after: aDateTime
]

{ #category : #'as yet unclassified' }
SPDeleteCommitsWithImportErrors >> executeForRepoDirect: aRepo after: aDateTime [

	| query commits errorCommits |
	
	query := Query read: SPGitRepo where: [ :e | e id = aRepo id ].
	query retrieve: [ :e | e commits ].
	
	commits := self glorpSession execute: query.
	commits := commits select: [ :each | each datetime > aDateTime ].

	errorCommits := commits select: [ :each | each isImportError ].
	errorCommits := errorCommits sorted: [ :a :b | a datetime > b datetime ].
	
	self logInfo: 'Found ', errorCommits size asString, ' commits with errors in ', aRepo url. 
	
	errorCommits do: [ :each | self deleteCommit: each ]
	
]

{ #category : #'as yet unclassified' }
SPDeleteCommitsWithImportErrors >> executeForRepoRef: aRepoToCommitRef after: aDateTime [

	| commits errorCommits |
	
	commits := aRepoToCommitRef commit withAllParentsAfter: aDateTime.

	errorCommits := commits select: [ :each | each isImportError ].
	errorCommits := errorCommits sorted: [ :a :b | a datetime > b datetime ].
	
	self logInfo: 'Found ', errorCommits size asString, ' commits with errors in ', aRepoToCommitRef name. 
	
	errorCommits do: [ :each | self deleteCommit: each ]
	
]
