Class {
	#name : #SPGitCommitIceBuilder,
	#superclass : #SPGitCommitBuilder,
	#instVars : [
		'iceCommit',
		'icePackages',
		'writeClass',
		'sourceDirectory',
		'iceAncestors',
		'spiderAncestors'
	],
	#category : #'Spider-Model-Git-Ice'
}

{ #category : #building }
SPGitCommitIceBuilder >> build [

	| packages author |
	
	spiderAncestors := self buildAncestors.
	packages := self buildPackages.
	author := SPGitAuthor name: iceCommit author email: iceCommit libgitCommit author email.
	
	^ SPGitCommit new initWithSha: (ByteArray readHexFrom: iceCommit id)
			author: author 
			datetime: iceCommit datetime 
			message: iceCommit comment
			parents: spiderAncestors 
			packages: packages
]

{ #category : #building }
SPGitCommitIceBuilder >> buildAncestor: ancestorCommit [

	| builder |
	
	builder := self class new
		setContext: context;
		setIceCommit: ancestorCommit;
		yourself.
		
	^ builder build


]

{ #category : #building }
SPGitCommitIceBuilder >> buildAncestors [

	^ self iceAncestors collect: [ :each |
			self buildAncestor: each ]
]

{ #category : #building }
SPGitCommitIceBuilder >> buildPackageFromDiff: iceDiff [

	| packageName mcSnapshot |

	packageName := iceDiff value name.
	mcSnapshot := iceCommit snapshotFor: (self icePackageNamed: packageName ifNone: [ ^ nil ]).
	^ self buildPackageFromSnapshot: mcSnapshot name: packageName
]

{ #category : #building }
SPGitCommitIceBuilder >> buildPackageFromSnapshot: mcSnapshot name: aName [

	| packageBuilder |
	
	packageBuilder := context packageRepo newMCBuilder.
	packageBuilder name: aName.
	packageBuilder snapshot: mcSnapshot.
	
	^ packageBuilder build
]

{ #category : #building }
SPGitCommitIceBuilder >> buildPackages [

	"^ self fixReaderClassDuring: [ self buildPackagesInternal ]	"
		
	^ self buildPackagesInternal

]

{ #category : #building }
SPGitCommitIceBuilder >> buildPackagesFromDiffs: iceDiff from: spiderAncestor [

	| newPackages |
	
	newPackages := spiderAncestor packages
		inject: Dictionary new
		into: [ :dict :each | dict at: each name put: each; yourself ].
	
	iceDiff packages do: [ :eachNode |
		| packageName newPackage |
		packageName := eachNode value name.
		eachNode value isRemoval
			ifTrue: [ newPackages removeKey: packageName ]
			ifFalse: [ 
				newPackage := self buildPackageFromDiff: eachNode.
				newPackage notNil
					ifTrue: [ newPackages at: packageName put: newPackage ] ] ].

	^ newPackages
]

{ #category : #building }
SPGitCommitIceBuilder >> buildPackagesFromSnapshots [

	| mcSnapshpot packages |
	
	packages := OrderedCollection new.
	self icePackages do: [ :each |
		mcSnapshpot := iceCommit snapshotFor: each.
		packages add: (self buildPackageFromSnapshot: mcSnapshpot name: each name) ].
	
	^ packages
]

{ #category : #building }
SPGitCommitIceBuilder >> buildPackagesInternal [

	| iceDiffs minEntry minSpiderAncestor |
	
	(spiderAncestors allSatisfy: [ :each | each packages isEmpty ])
		ifTrue: [ ^ self buildPackagesFromSnapshots ].
	
	iceDiffs := (self iceAncestors select: [ :each | each writerClass = iceCommit writerClass ])
		collect: [ :each | each -> (iceCommit diffTo: each) ].
		
	iceDiffs isEmpty
		ifTrue: [ ^ self buildPackagesFromSnapshots ].
		
	"choose the ancestor with the smallest amount of diffs"
	minEntry := iceDiffs detectMin: [ :each | each value packages size ].
	minSpiderAncestor := self spiderAncestorWithGitId: minEntry key id
		ifNone: [ ^ self buildPackagesFromSnapshots ].
		
	^ self buildPackagesFromDiffs: minEntry value from: minSpiderAncestor
		
			
	

]

{ #category : #building }
SPGitCommitIceBuilder >> fixReaderClassDuring: aBlock [

	| oldCommit |
	
	oldCommit := self iceCommit repository workingCopy referenceCommit.
	^ [ 
		self iceCommit repository workingCopy referenceCommit: self iceCommit.
		aBlock value
	] ensure: [ self iceCommit repository workingCopy referenceCommit: oldCommit ]
]

{ #category : #accessing }
SPGitCommitIceBuilder >> iceAncestors [

	^ iceAncestors ifNil: [ iceAncestors := iceCommit ancestors ]
]

{ #category : #accessing }
SPGitCommitIceBuilder >> iceCommit [

	^ iceCommit
]

{ #category : #accessing }
SPGitCommitIceBuilder >> icePackageNamed: aName ifNone: aBlock [

	^ self icePackages detect: [ :each | each name = aName ] ifNone: aBlock
]

{ #category : #accessing }
SPGitCommitIceBuilder >> icePackages [

	^ icePackages ifNil: [ 
			icePackages := iceCommit packageNames collect: [ :each | 
				IcePackage named: each repository: iceCommit repository ] ]
]

{ #category : #initialization }
SPGitCommitIceBuilder >> setIceCommit: aCommit [

	iceCommit := aCommit
]

{ #category : #accessing }
SPGitCommitIceBuilder >> sourceDirectory [

	^ sourceDirectory ifNil: [
			sourceDirectory := iceCommit fileSystem resolve: (iceCommit project sourceDirectory) ]
]

{ #category : #accessing }
SPGitCommitIceBuilder >> spiderAncestorWithGitId: aString ifNone: aBlock [

	^ spiderAncestors detect: [ :each | each gitId = aString ] ifNone: aBlock
]

{ #category : #accessing }
SPGitCommitIceBuilder >> writerClass [

	^ writeClass ifNil: [ iceCommit writerClass ]
]
