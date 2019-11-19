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
SPLibGitCommitBuilder >> buildPackageFromSnapshot: mcSnapshot name: aName [

	| packageBuilder thePackage |
	
	packageBuilder := context packageRepo newMCBuilder.
	packageBuilder name: aName.
	packageBuilder snapshot: mcSnapshot.
	
	self logInfo: ('Building package ', aName, ' from commit ', (self commit id hexString first: 7), ' ...').
	thePackage := packageBuilder build.
	self logInfo: (thePackage id ifNil: [ 'New version created' ] ifNotNil: [ 'Version already present: ', thePackage id asString ]).	
	^ thePackage 
]

{ #category : #internal }
SPLibGitCommitBuilder >> buildPackages [
	
	| resolver parentReaders |
	
	resolver := SPGitFormatResolver onGitCommit: commit.
	resolver resolve.
	resolver packagesPresent 
		ifFalse: [ ^ self ].
	
	codeReader := resolver codeReader.
	sourceDir := resolver sourceDirectory.
	format := resolver format.
	
	parentReaders := self parentCodeReaders.
	
	packages := codeReader packageNames collect: [ :each |
		| sha parentAssoc snapshot |
		sha := codeReader getPackageSha: each.
		parentAssoc := parentReaders 
			detect: [ :eachAssoc | (eachAssoc value getPackageSha: each) = sha ]
			ifNone: [ nil ].
		parentAssoc 	notNil
			ifTrue: [ parentAssoc key packageNamed: each ]
			ifFalse: [ 
				snapshot := codeReader getPackageSnapshot: each.
				self buildPackageFromSnapshot: snapshot name: each ]	]
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
SPLibGitCommitBuilder >> commit: aLGitCommit [
	commit := aLGitCommit
]

{ #category : #initialization }
SPLibGitCommitBuilder >> initialize [

	super initialize.
	
	packages := OrderedCollection new
]

{ #category : #accessing }
SPLibGitCommitBuilder >> lgitRepo [

	^ self commit repository
]

{ #category : #accessing }
SPLibGitCommitBuilder >> packages [

	^ packages
]

{ #category : #'as yet unclassified' }
SPLibGitCommitBuilder >> parentCodeReaders [

	^ (parents select: [ :each | each hasPackages ])
			collect: [ :eachCommit |
				eachCommit -> (SPCodeReader onSPCommit: eachCommit in: self lgitRepo) ]
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
