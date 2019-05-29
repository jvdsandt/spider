Class {
	#name : #SPLibGitCommitBuilder,
	#superclass : #SPGitCommitBuilder,
	#instVars : [
		'commit',
		'packages',
		'sourceDir',
		'format'
	],
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #building }
SPLibGitCommitBuilder >> build [

	| author |

	self importPackages.
	
	author := SPGitSignature name: commit author name asByteArray utf8Decoded 
			email: commit author email asByteArray utf8Decoded
			datetime: commit time asDateAndTime
			offset: commit time offset.
	
	^ SPGitCommit sha: commit id asByteArray
			authorSignature: author 
			message: commit message
			parents: #() 
			packages: packages
			sourceDir: sourceDir
			format: format
]

{ #category : #'as yet unclassified' }
SPLibGitCommitBuilder >> buildPackageFromSnapshot: mcSnapshot name: aName [

	| packageBuilder |
	
	packageBuilder := context packageRepo newMCBuilder.
	packageBuilder name: aName.
	packageBuilder snapshot: mcSnapshot.
	
	^ packageBuilder build
]

{ #category : #accessing }
SPLibGitCommitBuilder >> commit [
	^ commit
]

{ #category : #accessing }
SPLibGitCommitBuilder >> commit: anObject [
	commit := anObject
]

{ #category : #'as yet unclassified' }
SPLibGitCommitBuilder >> importPackages [
	
	| resolver codeReader |
	
	resolver := SPGitFormatResolver onGitCommit: commit.
	resolver resolve.
	resolver packagesPresent 
		ifFalse: [ ^ self ].
		
	sourceDir := resolver sourceDirectory.
	format := resolver format.
		
	codeReader := resolver codeReader.
	codeReader packageNames do: [ :each |
		| snapshot |
		snapshot := codeReader getPackageSnapshot: each.
		packages add: (self buildPackageFromSnapshot: snapshot name: each) ]
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
