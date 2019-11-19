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
		'rootId',
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
	"Compare the receivers packages with the packages in <olderCommits>. Answer a collection of
	SPAddedPackage, SPUpdatedPackage and SPRemovedPackage objects."

	| oldPackagesByName result removedByName |
	
	oldPackagesByName := olderCommits collect: [ :each | each packagesByDiffKey ].
	result := OrderedCollection new.
	
	self packages do: [ :eachPackage |
		| oldPackages |
		oldPackages := oldPackagesByName collect: [ :each | each removeKey: eachPackage diffKey ifAbsent: [ nil ] ].
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
	
	^ result sorted: [ :a :b | a name <= b name ]
]

{ #category : #accessing }
SPGitCommit >> datetime [
	^ self authorSignature datetime
]

{ #category : #printing }
SPGitCommit >> description [

	^ String streamContents: [ :s | self printDescriptionOn: s ]
]

{ #category : #accessing }
SPGitCommit >> diffs [
	^ self comparePackagesWithAll: self parents
]

{ #category : #printing }
SPGitCommit >> diffsPrintString [

	^ String streamContents: [ :s | self printDiffsOn: s ]
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
SPGitCommit >> isFileTreeFormat [

	^ format = #filetree
]

{ #category : #testing }
SPGitCommit >> isImportError [

	^ self status = #importerror
]

{ #category : #testing }
SPGitCommit >> isImported [

	^ self status = #imported
]

{ #category : #testing }
SPGitCommit >> isTonelFormat [ 

	^ format = #tonel
]

{ #category : #accessing }
SPGitCommit >> message [
	^ message
]

{ #category : #accessing }
SPGitCommit >> messageLine [

	| msg index maxLength |
	
	maxLength := 100.
	msg := self message ifNil: [ '' ].
	index := msg indexOf: Character cr.
	index := index > 0
		ifTrue: [ index min: (msg indexOf: Character lf) ]
		ifFalse: [ msg indexOf: Character lf ].
	
	^ (index > maxLength or: [ index = 0 and: [ msg size > maxLength ] ])
			ifTrue: [ (msg copyFrom: 1 to: 97), '...' ]
			ifFalse: [ 
				index > 0
					ifTrue: [ msg copyFrom: 1 to: index-1 ]
					ifFalse: [ msg ] ]
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
SPGitCommit >> packagesByDiffKey [
	^ self packages
			inject: Dictionary new
			into: [ :dict :each | dict at: each diffKey put: each; yourself ]
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
SPGitCommit >> printDescriptionOn: aStream [

	aStream 
		nextPutAll: 'Commit ';
		nextPutAll: self shaShortString;
		nextPutAll: ' by ';
		nextPutAll: self authorName;
		nextPutAll: ' at ';
		nextPutAll: self datetime asString;
		cr;
		nextPutAll: self messageLine;
		cr.
		
	SPDiffPrinter new
		tabs: 1;
		stream: aStream;
		visitAll: self diffs
]

{ #category : #printing }
SPGitCommit >> printDiffsOn: aStream [

	SPDiffPrinter new
		stream: aStream;
		visitAll: self diffs
]

{ #category : #printing }
SPGitCommit >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	aStream nextPutAll: self shaShortString.
	aStream nextPut: $)
]

{ #category : #initialization }
SPGitCommit >> privRootId: anInteger [
	rootId := anInteger
]

{ #category : #accessing }
SPGitCommit >> rootId [
	^ rootId
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
