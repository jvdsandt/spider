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

	| spCommit author status |
	
	"Already present?"
	spCommit := self gitRepo getCommitByShaString: commit id hexString ifAbsent: [ nil ].
	spCommit notNil
		ifTrue: [ ^ spCommit ].

	self buildParents.
	[ 
		self buildPackages.
		status := #imported.
	] on: Error do: [ :ex | 
		self reportImportError: ex.
		status := #importerror.
		packages := #().
	].
	
	author := SPGitSignature name: commit author name asByteArray utf8Decoded 
			email: commit author email asByteArray utf8Decoded
			datetime: commit time asDateAndTime
			offset: commit time offset.
	
	spCommit := SPGitCommit sha: commit id asByteArray
			authorSignature: author 
			message: commit message
			parents: parents
			packages: packages
			status: status
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
	
	self logInfo: ('Building package ', aName, ' from commit ', (self commit id hexString first: 7)).
	
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
		ifFalse: [ self buildPackagesFromDiffs: diffParents ].
		
	codeReader packageNames sorted asArray = (self packages collect: #name) sorted asArray
		ifFalse: [ self halt ]
		
		

]

{ #category : #internal }
SPLibGitCommitBuilder >> buildPackagesFromDiff: aParent [

	| oldCommit diff tempPackages |
	
	oldCommit := LGitCommit of: commit repository fromHexString: aParent shaString.
	
	diff := (SPGitLibGitDiff forFormat: format)
		initWithOld: oldCommit oldSourceDir: aParent sourceDir new: commit newSourceDir: sourceDir;
		yourself.
		
	tempPackages := aParent packagesByName copy.
	diff updatedPackages sorted do: [ :each |
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

	| parentForDiff |
	
	parentForDiff := aParents first.
	[ parentForDiff notNil and: [ parentForDiff isImportError ] ]
		whileTrue: [ 
			parentForDiff := parentForDiff parents isEmpty
				ifTrue: [ nil ]
				ifFalse: [ parentForDiff parents first ] ].
			
	parentForDiff isNil
		ifTrue: [ self buildAllPackages ]
		ifFalse: [ self buildPackagesFromDiff: parentForDiff ]
]

{ #category : #internal }
SPLibGitCommitBuilder >> buildParents [

	| parentCommits ids |
	
	parentCommits := commit parents.
	
	parents := parentCommits collect: [ :each |
		self gitRepo getCommitByShaString: each id hexString ifAbsent: [ 
			self class new
				setContext: context;
				commit: each;
				build ] ].
		
	"Remove duplicate parents"
	ids := Set new.
	parents := parents reject: [ :each | 
		(ids includes: each sha)
				ifTrue: [ true ]
				ifFalse: [ ids add: each sha. false ] ]
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

{ #category : #internal }
SPLibGitCommitBuilder >> reportImportError: anError [

	| stack |
	
	stack := String streamContents: [ :str | 
		| stContext |
		stContext := anError signalerContext.
		[ stContext isNil ] whileFalse: [
			[ str print: stContext; lf ] ifError: [ str nextPutAll: 'PRINTING ERROR'; lf].
			stContext := stContext sender ] ].
	
	self logError: (String streamContents: [ :str |
		str nextPutAll: 'Import of commit ';
			nextPutAll: commit id hexString;
			nextPutAll: ' failed'; lf;
			nextPutAll: stack ])		

]
