Class {
	#name : #SPDeleteCommitsWithImportErrors,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #examples }
SPDeleteCommitsWithImportErrors >> exampleDeleteCalypsoErrors [
	"SPWebContext default do: [ self new exampleDeleteCalypsoErrors ]"

	| repo dt |
	
	repo := self gitRepo getRepoByUrl: 'https://github.com/pharo-ide/Calypso.git'
		ifAbsent: [ self error: 'Repo not found' ].
		
	dt := DateAndTime fromUnixTime: 0.
	
	self executeForRepo: repo after: dt
]

{ #category : #examples }
SPDeleteCommitsWithImportErrors >> exampleDeleteIcebergErrors [
	"self new context: SPWebContext default context; exampleDeleteIcebergErrors"

	| repo dt |
	
	repo := self gitRepo getRepoByUrl: 'https://github.com/pharo-vcs/iceberg.git'
		ifAbsent: [ self error: 'Repo not found' ].
		
	dt := DateAndTime fromUnixTime: 0.
	
	self executeForRepo: repo after: dt
]

{ #category : #examples }
SPDeleteCommitsWithImportErrors >> exampleDeleteMagritteErrors [
	"SPWebContext default do: [ self new exampleDeleteMagritteErrors ]"

	| repo dt |
	
	repo := self gitRepo getRepoByUrl: 'https://github.com/magritte-metamodel/magritte.git'
		ifAbsent: [ self error: 'Repo not found' ].
		
	dt := DateAndTime fromUnixTime: 0.
	
	self executeForRepo: repo after: dt
]

{ #category : #examples }
SPDeleteCommitsWithImportErrors >> exampleDeleteMooseErrors [
	"SPWebContext default do: [ self new exampleDeleteMooseErrors ]"

	| repo dt |
	
	repo := self gitRepo getRepoByUrl: 'https://github.com/PolyMathOrg/PolyMath.git'
		ifAbsent: [ self error: 'Repo not found' ].
		
	dt := DateAndTime fromUnixTime: 0.
	
	self executeForRepo: repo after: dt
]

{ #category : #examples }
SPDeleteCommitsWithImportErrors >> exampleDeletePharoErrors [
	"SPWebContext default do: [ self new exampleDeletePharoErrors ]"

	| repo dt |
	
	repo := self gitRepo getRepoByUrl: 'https://github.com/pharo-project/pharo.git'
		ifAbsent: [ self error: 'Repo not found' ].
		
	dt := DateAndTime fromString: '2020-01-01T00:00:00'.
	
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

	| commits errorCommits |
	
	commits := aRepo allCommitsAfter: aDateTime.

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

{ #category : #'as yet unclassified' }
SPDeleteCommitsWithImportErrors >> executeForRootId: anInteger [
	"SPWebContext default do: [ self new executeForRootId: 663 ]"

	self executeForRootId: anInteger after: (DateAndTime fromUnixTime: 0) 	
]

{ #category : #'as yet unclassified' }
SPDeleteCommitsWithImportErrors >> executeForRootId: anInteger after: aDateTime [

	| commits errorCommits |
	
	commits := self gitRepo getCommitsWithRootId: anInteger after: aDateTime.

	errorCommits := commits select: [ :each | each isImportError ].
	errorCommits := errorCommits sorted: [ :a :b | a datetime > b datetime ].
	
	self logInfo: 'Found ', errorCommits size asString, ' commits with errors foor rootId ', anInteger asString. 
	
	errorCommits do: [ :each | self deleteCommit: each ]
	
]
