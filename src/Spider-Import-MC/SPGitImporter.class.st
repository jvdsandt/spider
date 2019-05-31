Class {
	#name : #SPGitImporter,
	#superclass : #SPImporter,
	#instVars : [
		'lgitRepo'
	],
	#classVars : [
		'ReposLocation'
	],
	#category : #'Spider-Import-MC'
}

{ #category : #actions }
SPGitImporter class >> cloneRepo: repoUrl to: aLocation [

	| location repo |

	location := aLocation asFileReference.
	location exists
		ifTrue: [ self error: 'Location already exists' ].

	location ensureCreateDirectory.
	repo := LGitRepository on: location.
	repo clone: repoUrl options: self defaultCloneOptions.
	
	^ repo
]

{ #category : #accessing }
SPGitImporter class >> defaultCloneOptions [

	^ LGitCloneOptions defaults
		fetchOptions: self defaultFetchOptions;
		prim_bare: true;
		yourself
]

{ #category : #accessing }
SPGitImporter class >> defaultFetchOptions [

	^ LGitFetchOptions defaults
		prim_download_tags: 1;
		yourself
]

{ #category : #accessing }
SPGitImporter class >> getLocalDirectoryFor: aRepoUrl [

	| url mainDir |
	
	(aRepoUrl beginsWith: 'https://')
		ifFalse: [ self error: 'Currently only https url''s are supported' ].
		
	url := aRepoUrl asZnUrl.
	mainDir := url host asLowercase.
	(mainDir endsWith: '.com')
		ifTrue: [ mainDir := mainDir allButLast: 4 ].
		
	^ self reposLocation asFileReference / mainDir / url path
]

{ #category : #actions }
SPGitImporter class >> import: aRepoUrl [

	^ (self newWithContext: self createContext repo: aRepoUrl) importAll
]

{ #category : #actions }
SPGitImporter class >> import: aRepoUrl revparse: aString [

	^ (self newWithContext: self createContext repo: aRepoUrl) importRevparse: aString
]

{ #category : #'instance creation' }
SPGitImporter class >> newWithContext: spiderContext repo: aRepoUrl [

	| localRef repo |
	
	localRef := self getLocalDirectoryFor: aRepoUrl.
	repo := localRef exists
		ifTrue: [ self updateRepoAt: localRef ]
		ifFalse: [ self cloneRepo: aRepoUrl to: localRef ].

	^ (self newWithContext: spiderContext)
			setLGitRepo: repo;
			yourself
]

{ #category : #accessing }
SPGitImporter class >> reposLocation [

	^ ReposLocation ifNil: [ '/tmp' ]
]

{ #category : #accessing }
SPGitImporter class >> reposLocation: aString [

	ReposLocation := aString
]

{ #category : #actions }
SPGitImporter class >> updateRepoAt: aLocation [

	| location repo |

	location := aLocation asFileReference.
	location exists
		ifFalse: [ self error: 'Location does not exist' ].
	
	repo := LGitRepository on: location.
	repo open.
	
	"(LGitRemote of: repo named: 'origin') 
		lookup; 
		fetch."
	repo fetchFrom: 'origin'.

	^ repo
]

{ #category : #'actions-internal' }
SPGitImporter >> doImport: lgitCommit [

	| startTS duration message |

	message := 'Import git commit {1} from {2}'	 format: { 
		lgitCommit id hexString first: 7.
		lgitCommit time asDateAndTime }.
	self logInfo: 'Starting ', message, ' ...'.
		
	startTS := Time millisecondClockValue.	
	context
		doTransaction: message
		with: [ 
			SPLibGitCommitBuilder new
				setContext: self context;
				commit: lgitCommit;
				build ].		
	duration := Time millisecondClockValue - startTS.
	self logInfo: 'Finished in ', duration asString, 'ms.'

]

{ #category : #accessing }
SPGitImporter >> gitRepo [

	^ self context gitRepo
]

{ #category : #actions }
SPGitImporter >> import: lgitCommit [

	lgitCommit parents do: [ :each |
		(self isAlreadyImported: each)
			ifFalse: [ self import: each ] ].

	self doImport: lgitCommit
]

{ #category : #actions }
SPGitImporter >> importAll [

	self lgitRepo branchesDo: [ :each |
		| lgitCommit |
		lgitCommit := each commit.
		(self isAlreadyImported: lgitCommit)
			ifFalse: [ self import: lgitCommit ] ]
]

{ #category : #actions }
SPGitImporter >> importRevparse: aString [

	| lgitCommit |
	
	lgitCommit := self lgitRepo revparse: aString.
	(lgitCommit notNil and: [ lgitCommit isCommit ])
		ifTrue: [ self import: lgitCommit ]
]

{ #category : #testing }
SPGitImporter >> isAlreadyImported: lgitCommit [

	^ self gitRepo includesCommitWithSha: lgitCommit id asByteArray
]

{ #category : #accessing }
SPGitImporter >> lgitRepo [
	^ lgitRepo
]

{ #category : #initialization }
SPGitImporter >> setLGitRepo: aRepo [

	lgitRepo := aRepo
]
