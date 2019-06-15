Class {
	#name : #SPGitImporter,
	#superclass : #SPImporter,
	#instVars : [
		'lgitRepo',
		'spGitRepo'
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
	self logInfo: 'Performing git clone'.
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
	
	self logInfo: 'Performing git fetch'.
	"(LGitRemote of: repo named: 'origin') 
		lookup; 
		fetch."
	repo fetchFrom: 'origin'.

	^ repo
]

{ #category : #'actions-internal' }
SPGitImporter >> branchNameFromRef: aRefName [

	| index |
	
	index := aRefName lastIndexOf: $/.
	^ aRefName allButFirst: index
]

{ #category : #'actions-internal' }
SPGitImporter >> deleteRefs: aRefColl [

	| message |
	
	aRefColl isEmptyOrNil
		ifTrue: [ ^ self ].

	message := 'Removing {1} refs from {2}' format: { aRefColl size. self spGitRepo url }.
	context
		doTransaction: message
		with: [ self gitRepo deleteRepoRefs: aRefColl from: self spGitRepo ]
]

{ #category : #'actions-internal' }
SPGitImporter >> doImport: lgitCommit [

	| startTS duration message |

	message := 'Import git commit {1} from {2}'	 format: { 
		lgitCommit id hexString first: 7.
		self spGitRepo url }.
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

{ #category : #'actions-internal' }
SPGitImporter >> getRemoteUrl [

	^ (LGitRemote of: self lgitRepo named: 'origin') 
			lookup;
			url
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

	| existingTags existingBranches tags branches |
	
	self logInfo: 'Checking ', self spGitRepo url.
	
	existingTags := Dictionary new.
	existingBranches := Dictionary new.
	(self gitRepo selectRepoRefsOf: self spGitRepo id) do: [ :eachRef |
		eachRef isBranch 
			ifTrue: [ existingBranches at: eachRef name put: eachRef ].
		eachRef isTag
			ifTrue: [ existingTags at: eachRef name put: eachRef ] ].
		
	tags := Dictionary new.
	self lgitRepo tags do: [ :each |
		| object ref |
		object := (self lgitRepo revparse: each) object.
		(object notNil and: [ object isCommit ])
			ifTrue: [ 
				ref := existingTags removeKey: each ifAbsent: [ nil ].
				(ref notNil and: [ ref shaString = object id hexString ])
					ifFalse: [ tags at: each put: object ] ] ].

	branches := Dictionary new.
	self lgitRepo remoteBranchesDo: [ :each |
		| branchName object ref |
		branchName := self branchNameFromRef: each name.
		object := each object.
		ref := existingBranches removeKey: branchName ifAbsent: [ nil ].
		(ref notNil and: [ ref shaString = object id hexString ])
			ifFalse: [ branches at: branchName put: object ] ].
		
	(branches notEmpty or: [ tags notEmpty ])
		ifTrue: [ 
			self logInfo: ('Importing {1} branches and {2} tags from {3}' format: { branches size. tags size. self spGitRepo url }).
			branches do: [ :each |
				(self isAlreadyImported: each)
					ifFalse: [ self import: each ] ].
			tags do: [ :each |
				(self isAlreadyImported: each)
					ifFalse: [ self import: each ] ].
			self updateBranches: branches.
			self updateTags: tags ].
		
	(existingBranches notEmpty or: [ existingTags notEmpty ])
		ifTrue: [ 
			self logInfo: ('Removing {1} branches and {2} tags from {3}' format: { existingBranches size. existingTags size. self spGitRepo url }).
			self deleteRefs: existingBranches values, existingTags values ].

]

{ #category : #actions }
SPGitImporter >> importRevparse: aString [

	| lgitCommit |
	
	lgitCommit := self lgitRepo revparse: aString.
	(lgitCommit notNil and: [ lgitCommit isCommit ])
		ifTrue: [ self import: lgitCommit ]
]

{ #category : #initialization }
SPGitImporter >> initSpiderGitRepo [

	spGitRepo := self gitRepo getGitRepoByUrl: self getRemoteUrl ifAbsent: [ nil ].
	spGitRepo isNil
		ifTrue: [ 
			context
				doTransaction: 'Create git repo ', self getRemoteUrl
				with: [ 
					spGitRepo := self gitRepo storeRepo: (SPGitRepo url: self getRemoteUrl) ] ].
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

	lgitRepo := aRepo.
	self initSpiderGitRepo.
]

{ #category : #accessing }
SPGitImporter >> spGitRepo [

	^ spGitRepo
]

{ #category : #'actions-internal' }
SPGitImporter >> updateBranches: aBranches [

	| message |
	
	aBranches isEmptyOrNil
		ifTrue: [ ^ self ].

	message := 'Import {1} branches from {2}' format: { aBranches size. self spGitRepo url }.
	context
		doTransaction: message
		with: [ 
			aBranches keysAndValuesDo: [ :eachName :eachCommit |
				| spCommit |
				spCommit := self gitRepo getCommitBySha: eachCommit id asByteArray ifAbsent: [ nil ].
				spCommit notNil
					ifTrue: [ 
						self gitRepo storeRepoRef: self spGitRepo type: SPGitRepoToCommitRef typeBranch named: eachName to: spCommit ] ] ]
]

{ #category : #'actions-internal' }
SPGitImporter >> updateTags: aTags [

	| message |

	aTags isEmptyOrNil
		ifTrue: [ ^ self ].
		
	message := 'Import {1} tags from {2}' format: { aTags size. self spGitRepo url }.
	context
		doTransaction: message
		with: [ 
			aTags keysAndValuesDo: [ :eachName :eachCommit |
				| spCommit |
				spCommit := self gitRepo getCommitBySha: eachCommit id asByteArray ifAbsent: [ nil ].
				spCommit notNil
					ifTrue: [ 
						self gitRepo storeRepoRef: self spGitRepo type: SPGitRepoToCommitRef typeTag named: eachName to: spCommit ] ] ].

]
