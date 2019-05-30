Class {
	#name : #SPLibGitCommitBuilder,
	#superclass : #SPGitCommitBuilder,
	#instVars : [
		'commit',
		'codeReader',
		'sourceDir',
		'format',
		'packages',
		'parents'
	],
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #building }
SPLibGitCommitBuilder >> build [

	| spCommit author |
	
	"Already present?"
	spCommit := self gitRepo getCommitBySha: commit id asByteArray ifAbsent: [ nil ].
	spCommit notNil
		ifTrue: [ ^ spCommit ].

	self buildParents.
	self buildPackages.
	
	author := SPGitSignature name: commit author name asByteArray utf8Decoded 
			email: commit author email asByteArray utf8Decoded
			datetime: commit time asDateAndTime
			offset: commit time offset.
	
	spCommit := SPGitCommit sha: commit id asByteArray
			authorSignature: author 
			message: commit message
			parents: parents
			packages: packages
			sourceDir: sourceDir
			format: format.
	self gitRepo storeCommit: spCommit.
	^ spCommit
]

{ #category : #internal }
SPLibGitCommitBuilder >> buildAllPackages [
	
	packages := codeReader packageNames collect: [ :each |
		| snapshot |
		snapshot := codeReader getPackageSnapshot: each.
		self buildPackageFromSnapshot: snapshot name: each ]
]

{ #category : #internal }
SPLibGitCommitBuilder >> buildPackageFromSnapshot: mcSnapshot name: aName [

	| packageBuilder |
	
	packageBuilder := context packageRepo newMCBuilder.
	packageBuilder name: aName.
	packageBuilder snapshot: mcSnapshot.
	
	^ packageBuilder build
]

{ #category : #internal }
SPLibGitCommitBuilder >> buildPackages [
	
	| resolver diffParents |
	
	resolver := SPGitFormatResolver onGitCommit: commit.
	resolver resolve.
	resolver packagesPresent 
		ifFalse: [ ^ self ].
	
	codeReader := resolver codeReader.
	sourceDir := resolver sourceDirectory.
	format := resolver format.
	
	diffParents := parents select: [ :each | each format = format and: [ each hasPackages ] ].
	diffParents isEmpty
		ifTrue: [ self buildAllPackages ]
		ifFalse: [ self buildPackagesFromDiffs: diffParents ]

]

{ #category : #internal }
SPLibGitCommitBuilder >> buildPackagesFromDiff: aParent [

	| oldCommit diff tempPackages |
	
	oldCommit := commit parents detect: [ :each | each id asByteArray = aParent sha ].
	
	diff := (SPGitLibGitDiff forFormat: format)
		initWithOld: oldCommit oldSourceDir: aParent sourceDir new: commit newSourceDir: sourceDir;
		yourself.
		
	tempPackages := aParent packagesByName copy.
	diff updatedPackages do: [ :each |
		| snapshot |
		snapshot := codeReader getPackageSnapshot: each ifAbsent: [ nil ].
		snapshot isNil
			ifTrue: [ tempPackages removeKey: each ]
			ifFalse: [ 
				| p |
				p := self buildPackageFromSnapshot: snapshot name: each.
				tempPackages at: each put: p ] ].
	packages := tempPackages values asArray
]

{ #category : #internal }
SPLibGitCommitBuilder >> buildPackagesFromDiffs: aParents [

	self buildPackagesFromDiff: aParents first
	

]

{ #category : #internal }
SPLibGitCommitBuilder >> buildParents [

	| parentCommits |
	
	parentCommits := commit parents.
	
	parents := parentCommits collect: [ :each |
		self gitRepo getCommitBySha: each id asByteArray ifAbsent: [ 
			self class new
				setContext: context;
				commit: each;
				build ] ]
]

{ #category : #accessing }
SPLibGitCommitBuilder >> commit [
	^ commit
]

{ #category : #accessing }
SPLibGitCommitBuilder >> commit: anObject [
	commit := anObject
]

{ #category : #initialization }
SPLibGitCommitBuilder >> initialize [

	super initialize.
	
	packages := OrderedCollection new
]

{ #category : #accessing }
SPLibGitCommitBuilder >> packages [

	^ packages
]
