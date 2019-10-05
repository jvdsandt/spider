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
SPGitCommit >> addAllTo: aSet after: aDateTime [
	"Add the receivers and all of its parents to <aSet>. If the receivers 
	is already present in <aSet> we assume that the parents are also already added
	to <aSet>."
	
	(self datetime <= aDateTime or: [ aSet includes: self ])
		ifTrue: [ ^ self ].
		
	aSet add: self.
	self parents do: [ :each | each addAllTo: aSet after: aDateTime ].
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

{ #category : #accessing }
SPGitCommit >> children [

	"^ self glorpSession read: self class where: [ :e | e parents includes: self ]"
	
	| q |
	
	q := Query read: self class where: [ :e | e id = self id ].
	q retrieve: [ :e | e children ].
	^ self glorpSession execute: q
]

{ #category : #comparing }
SPGitCommit >> comparePackagesWith: olderCommit [

	^ self comparePackagesWithAll: (Array with: olderCommit)
]

{ #category : #comparing }
SPGitCommit >> comparePackagesWithAll: olderCommits [
	"Answer a collection of Added, Removed or Updated packages."

	| oldPackagesByName result removedByName |
	
	oldPackagesByName := olderCommits collect: [ :each | each packagesByName ].
	result := OrderedCollection new.
	
	self packages do: [ :eachPackage |
		| oldPackages |
		oldPackages := oldPackagesByName collect: [ :each | each removeKey: eachPackage name ifAbsent: [ nil ] ].
		oldPackages := oldPackages reject: #isNil.
		oldPackages isEmpty
			ifTrue: [ result add: (SPAddedPackage added: eachPackage) ]
			ifFalse: [ 
				(oldPackages anySatisfy: [ :each | each = eachPackage ])
					ifFalse: [ result add: (SPUpdatedPackage old: oldPackages updated: eachPackage) ] ] ].
			
	removedByName := Dictionary new.		
	oldPackagesByName do: [ :eachDict |
		eachDict keysAndValuesDo: [ :eachName :each |
			(removedByName at: eachName ifAbsentPut: [ OrderedCollection new ])
				add: each ] ].
	result addAll: (removedByName collect: [ :each | SPRemovedPackage removed: each ]).
	^ result
]

{ #category : #accessing }
SPGitCommit >> datetime [
	^ self authorSignature datetime
]

{ #category : #accessing }
SPGitCommit >> diffs [
	^ self comparePackagesWithAll: self parents
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

{ #category : #accessing }
SPGitCommit >> withAllParentsAfter: aDateTime [

	| coll |

	coll := Set new.
	self addAllTo: coll after: aDateTime.
	^ coll
]
