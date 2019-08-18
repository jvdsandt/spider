Class {
	#name : #SPGitCommit,
	#superclass : #SPGlorpNode,
	#instVars : [
		'shaString',
		'authorSignature',
		'message',
		'parents',
		'packages',
		'status',
		'sourceDir',
		'format'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #'instance creation' }
SPGitCommit class >> sha: hashBytes authorSignature: anAuthorSig message: aMessage parents: aParents packages: aPackages status: statusSymbol sourceDir: aDir format: aFormat [

	^ self new initWithSha: hashBytes 
			authorSignature: anAuthorSig 
			message: aMessage 
			parents: aParents 
			packages: aPackages 
			status: statusSymbol
			sourceDir: aDir 
			format: aFormat
]

{ #category : #comparing }
SPGitCommit >> <= other [

	^ self datetime <= other datetime
]

{ #category : #comparing }
SPGitCommit >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ shaString = other shaString and: [ authorSignature = other authorSignature ]
]

{ #category : #adding }
SPGitCommit >> addIdsTo: aSet [
	"Add the receivers id and id's of its parents to <aSet>. If the receivers id
	is already present in <aSet> we assume that the parents are also already added
	to <aSet>."
	
	(aSet includes: self id)
		ifTrue: [ ^ self ].
		
	aSet add: self id.
	self parents do: [ :each | each addIdsTo: aSet ].
]

{ #category : #accessing }
SPGitCommit >> authorEmail [
	^ self authorSignature email
]

{ #category : #accessing }
SPGitCommit >> authorName [
	^ self authorSignature name
]

{ #category : #accessing }
SPGitCommit >> authorSignature [
	^ authorSignature
]

{ #category : #comparing }
SPGitCommit >> comparePackagesWith: olderCommit [

	| oldPackages result |
	
	oldPackages := olderCommit packagesByName.
	result := OrderedCollection new.
	
	self packages do: [ :each |
		| oldPackage |
		oldPackage := oldPackages removeKey: each name ifAbsent: [ nil ].
		oldPackage isNil
			ifTrue: [ result add: (SPAddedPackage added: each) ]
			ifFalse: [ 
				oldPackage = each
					ifFalse: [ result add: (SPUpdatedPackage old: oldPackage updated: each) ] ] ].
	oldPackages do: [ :each |
		result add: (SPRemovedPackage removed: each) ].
	^ result
]

{ #category : #accessing }
SPGitCommit >> datetime [
	^ self authorSignature datetime
]

{ #category : #accessing }
SPGitCommit >> diffs [

	self parents isEmpty
		ifTrue: [ 
			^ self packages collect: [ :each | SPAddedPackage added: each ] ].
		
	^ self comparePackagesWith: self parents first
]

{ #category : #accessing }
SPGitCommit >> format [
	^ format
]

{ #category : #testing }
SPGitCommit >> hasPackages [

	^ packages notEmpty
]

{ #category : #comparing }
SPGitCommit >> hash [

	^ shaString hash
]

{ #category : #accessing }
SPGitCommit >> historyList: maxSize [

	| commits |

	(maxSize <= 1 or: [ self parents isEmpty ])
		ifTrue: [ ^ Array with: self ].
		
	self parents size = 1
		ifTrue: [ ^ (Array with: self), (self parents first historyList: maxSize - 1) ].
		
	commits := Set new.
	self parents do: [ :each | commits addAll: (each historyList: maxSize - 1) ].
	commits := (Array with: self), commits sorted.
	commits size > maxSize
		ifTrue: [ commits := commits copyFrom: 1 to: maxSize ].
	^ commits
]

{ #category : #initialization }
SPGitCommit >> initWithSha: hashBytes authorSignature: anAuthorSig message: aMessage parents: aParents packages: aPackages status: statusSymbol sourceDir: aDir format: aFormat [

	shaString := hashBytes hex.
	authorSignature := anAuthorSig.
	message := aMessage.
	parents := aParents asArray.
	packages := aPackages asArray.
	status := statusSymbol.
	sourceDir := aDir.
	format := aFormat
]

{ #category : #testing }
SPGitCommit >> isImportError [

	^ self status = #importerror
]

{ #category : #testing }
SPGitCommit >> isImported [

	^ self status = #imported
]

{ #category : #accessing }
SPGitCommit >> message [
	^ message
]

{ #category : #accessing }
SPGitCommit >> packageNamed: aName [

	^ self packages detect: [ :each | each name = aName ]
]

{ #category : #accessing }
SPGitCommit >> packageNames [

	^ self packages collect: [ :each | each name ]
]

{ #category : #accessing }
SPGitCommit >> packages [
	^ packages
]

{ #category : #accessing }
SPGitCommit >> packagesByName [
	^ self packages
			inject: Dictionary new
			into: [ :dict :each | dict at: each name put: each; yourself ]
]

{ #category : #accessing }
SPGitCommit >> parents [
	^ parents
]

{ #category : #printing }
SPGitCommit >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	aStream nextPutAll: self shaShortString.
	aStream nextPut: $)
]

{ #category : #accessing }
SPGitCommit >> sha [
	^ ByteArray readHexFrom: self shaString
]

{ #category : #accessing }
SPGitCommit >> shaShortString [
	^ self shaString first: 7
]

{ #category : #accessing }
SPGitCommit >> shaString [
	^ shaString
]

{ #category : #accessing }
SPGitCommit >> sourceDir [
	^ sourceDir
]

{ #category : #accessing }
SPGitCommit >> status [
	^ status
]
