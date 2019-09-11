Class {
	#name : #SPGitImportChecker,
	#superclass : #SPImporter,
	#instVars : [
		'spiderRepo',
		'lgitRepo',
		'invalidCommits',
		'validCommitShas'
	],
	#category : #'Spider-Import-MC'
}

{ #category : #examples }
SPGitImportChecker class >> checkAll [

	SPWebContext default do: [ 
		self checkAllIn: SPCurrentContext value ]
]

{ #category : #examples }
SPGitImportChecker class >> checkAllIn: aContext [

	| repos |
	
	repos := aContext gitRepo selectReposByUrl: 0 limit: 100000.
	
	repos do: [ :each |
		| localRef |
		localRef := SPGitImporter getLocalDirectoryFor: each url.
		localRef exists
			ifTrue: [ 
				self logInfo: 'Checking ', each url, ' ...'.
				(self newWithContext: aContext repoUrl: each url)
					checkAll;
					release ] ]
]

{ #category : #examples }
SPGitImportChecker class >> exampleMagritte [
	
	SPWebContext default do: [ 
		| instance |
		instance := self newWithContext: SPCurrentContext value
				repoUrl: 'https://github.com/magritte-metamodel/magritte.git'.
				
		instance checkAll.
		"instance deleteInvalidCommits."
		instance release ]
]

{ #category : #examples }
SPGitImportChecker class >> exampleMoose [
	
	SPWebContext default do: [ 
		| instance |
		instance := self newWithContext: SPCurrentContext value
				repoUrl: 'https://github.com/moosetechnology/Moose.git'.
				
		instance checkAll.
		instance release ]
]

{ #category : #examples }
SPGitImportChecker class >> exampleTealight [
	
	SPWebContext default do: [ 
		| instance |
		instance := self newWithContext: SPCurrentContext value
				repoUrl: 'https://github.com/astares/Tealight.git'.
				
		instance checkAll.
		instance deleteInvalidCommits.
		instance release ]
]

{ #category : #'instance creation' }
SPGitImportChecker class >> newWithContext: aSPiderContext repoUrl: aRepoUrl [

	| repo |
	
	repo := aSPiderContext gitRepo getGitRepoByUrl: aRepoUrl 
		ifAbsent: [ self error: 'Repo not found' ].
	^ self new initWithContext: aSPiderContext repo: repo
]

{ #category : #actions }
SPGitImportChecker >> checkAll [

	spiderRepo commitRefs do: [ :each |
		self checkSha: each commit shaString ].
	
	self logInfo: ('Repo: {1} valid commits: {2} invalid commits: {3}' format: {
		spiderRepo url.
		validCommitShas size.
		invalidCommits size })
]

{ #category : #actions }
SPGitImportChecker >> checkSha: aSha [

	| spiderCommit allCommits |
	
	spiderCommit := self gitRepo getCommitByShaString: aSha 
		ifAbsent: [ self error: 'SpiderCommit not found' ].
	allCommits := self gitRepo selectAllParentsOf: spiderCommit id.
	self logInfo: ('Checking {1} commits of repo {2}' format: { allCommits size. spiderRepo url }).

	allCommits reverseDo: [ :each |
		self checkSpiderCommit: each ].
	self checkSpiderCommit: spiderCommit
]

{ #category : #actions }
SPGitImportChecker >> checkSpiderCommit: spiderCommit [

	| lgitCommit |
	
	(self isAlreadyCheacked: spiderCommit shaString)
		ifTrue: [ ^ self ].
	
	lgitCommit := lgitRepo revparse: spiderCommit shaString.
	(lgitCommit isNil or: [ lgitCommit isCommit not ])
		ifTrue: [ self error: 'LGitCommit not found' ].

	self checkSpiderCommit: spiderCommit lgitCommit: lgitCommit 	


]

{ #category : #'actions-internal' }
SPGitImportChecker >> checkSpiderCommit: spiderCommit lgitCommit: lgitCommit [

	| resolver codeReader lgitPackageNames |

	resolver := SPGitFormatResolver onGitCommit: lgitCommit.
	resolver resolve.
	codeReader := [ resolver codeReader ] on: Error do: [ :ex | nil ].
	(codeReader isNil and: [ spiderCommit packages isEmpty ])
		ifTrue: [ ^ self ].
	
	lgitPackageNames := codeReader packageNames sorted.
	(lgitPackageNames isEmpty and: [ spiderCommit packages isEmpty ])
		ifTrue: [ ^ self ].

	resolver format = spiderCommit format
		ifFalse: [ self error: 'Format mismatch' ].
	resolver sourceDirectory = spiderCommit sourceDir
		ifFalse: [ self error: 'Source directory mismatch' ].
	
	lgitPackageNames size > spiderCommit packages size
		ifTrue: [ 
			invalidCommits add: spiderCommit.
			self logWarn: ('{1} {2} missing packages: {3}' format: {
				spiderRepo url.
				spiderCommit shaShortString.
				lgitPackageNames copyWithoutAll: spiderCommit packageNames }).
			^ self ].
		
	lgitPackageNames sorted asArray ~= spiderCommit packageNames sorted asArray
		ifTrue: [ 
			invalidCommits add: spiderCommit.
			self logWarn: ('{1} {2} package mismatch' format: {
				spiderRepo url.
				spiderCommit shaShortString }).
			^ self ].
			
	validCommitShas add: spiderCommit shaString.
	self logInfo: ('{1} {2} OK' format: {
		spiderRepo url.
		spiderCommit shaShortString }).


]

{ #category : #'actions-internal' }
SPGitImportChecker >> deleteCommit: spiderCommit [

	SPBatchOperation new
		context: self context;
		deleteCommit: spiderCommit
	
]

{ #category : #actions }
SPGitImportChecker >> deleteInvalidCommits [

	| toDelete |
	
	invalidCommits isEmptyOrNil 
		ifTrue: [ ^ self ].
	
	self logInfo: ('{1} deleting {2} commits' format: { spiderRepo url. invalidCommits size }).
	toDelete := invalidCommits sorted: [ :a :b |
		a datetime > b datetime ].
	
	toDelete do: [ :each | self deleteCommit: each ]
	
	
]

{ #category : #'initialize - release' }
SPGitImportChecker >> initWithContext: aContext repo: aSpiderRepo [

	| localRef |

	self initWithContext: aContext.
	spiderRepo := aSpiderRepo.

	localRef := SPGitImporter getLocalDirectoryFor: aSpiderRepo url.
	localRef exists
		ifFalse: [ self error: 'Local clone not found for ', aSpiderRepo url ].
		
	lgitRepo := LGitRepository on: localRef.
	lgitRepo open.

	validCommitShas := Set new.
	invalidCommits := Set new.
]

{ #category : #testing }
SPGitImportChecker >> isAlreadyCheacked: aSha [

	^ (validCommitShas includes: aSha) or: [ 
			invalidCommits anySatisfy: [ :each | each shaString = aSha ] ]
]

{ #category : #'initialize - release' }
SPGitImportChecker >> release [

	lgitRepo notNil
		ifTrue: [ lgitRepo free ].
	lgitRepo := nil.
	spiderRepo := nil.
	validCommitShas := nil.
	invalidCommits := nil
]
