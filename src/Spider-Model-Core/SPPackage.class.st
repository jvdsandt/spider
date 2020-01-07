Class {
	#name : #SPPackage,
	#superclass : #SPGlorpNode,
	#instVars : [
		'name',
		'packageHash',
		'classRefs',
		'comment'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPPackage class >> name: aPackageName classRefs: aClasses comment: commentString [

	^ self new initWithName: aPackageName classRefs: aClasses comment: commentString
]

{ #category : #comparing }
SPPackage >> <= other [

	^ self name <= other name
]

{ #category : #comparing }
SPPackage >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ name = other name and: [ self packageHash = other packageHash ]
]

{ #category : #accessing }
SPPackage >> behaviors [
	^ classRefs collect: [ :each | each spiderClass ]
]

{ #category : #initialization }
SPPackage >> calcPackageHash [

	| byteStream charStream |
	
	byteStream := WriteStream on: (ByteArray new: 800).
	charStream := ZnCharacterWriteStream on: byteStream encoding: ZnCharacterEncoder utf8.
	self printHashSignatureOn: charStream.
	^ SHA1 hashMessage: byteStream contents
]

{ #category : #accessing }
SPPackage >> classExtensionNamed: aName [

	^ (classRefs detect: [ :each | each isSpiderClassExtension and: [ each name = aName ] ]) spiderClass
]

{ #category : #accessing }
SPPackage >> classExtensionNames [
	^ self classExtensions collect: [ :each | each name ]
]

{ #category : #accessing }
SPPackage >> classExtensions [
	^ classRefs select: [ :each | each isSpiderClassExtension ]
]

{ #category : #accessing }
SPPackage >> classNamed: aName [

	^ (classRefs detect: [ :each | each name = aName and: [ each isSpiderClass ] ]) spiderClass
]

{ #category : #accessing }
SPPackage >> classNames [
	^ self classes collect: [ :each | each name ]
]

{ #category : #accessing }
SPPackage >> classRefNamed: aName [

	^ classRefs detect: [ :each | each name = aName ]
]

{ #category : #accessing }
SPPackage >> classRefs [
	^ classRefs
]

{ #category : #accessing }
SPPackage >> classRefsByDiffKey [
	^ self classRefs
			inject: Dictionary new
			into: [ :dict :each |
				dict 
					at: each diffKey put: each; 
					yourself ]
]

{ #category : #accessing }
SPPackage >> classRefsByName [
	^ self classRefs
			inject: Dictionary new
			into: [ :dict :each |
				dict 
					at: each spiderClassName put: each; 
					yourself ]
]

{ #category : #accessing }
SPPackage >> classes [
	^ classRefs select: [ :each | each isSpiderClass ]
]

{ #category : #accessing }
SPPackage >> comment [
	^ comment
]

{ #category : #comparing }
SPPackage >> compareClassesWith: olderPackage [

	^ self compareClassesWithAll: (Array with: olderPackage)
]

{ #category : #comparing }
SPPackage >> compareClassesWithAll: olderPackages [
	"Compare the receivers classes with the classes in <olderPackages>. Answer a collection of
	SPAddedClass, SPUpdatedClass and SPRemovedClass objects."

	| oldRefsByName result removedByName |
	
	oldRefsByName := olderPackages collect: [ :each | each classRefsByDiffKey ].
	result := OrderedCollection new.
	
	self classRefs do: [ :eachRef |
		| oldRefs |
		oldRefs := oldRefsByName collect: [ :each | each removeKey: eachRef diffKey ifAbsent: [ nil ] ].
		oldRefs := oldRefs reject: #isNil.
		oldRefs isEmpty
			ifTrue: [ result add: (SPAddedClass added: eachRef) ]
			ifFalse: [ 
				(oldRefs anySatisfy: [ :each | each = eachRef ])
					ifFalse: [ result add: (SPUpdatedClass old: oldRefs updated: eachRef) ] ] ].
			
	removedByName := Dictionary new.
	oldRefsByName do: [ :eachDict |
		eachDict keysAndValuesDo: [ :eachName :each |
			removedByName at: eachName put: (
				(removedByName at: eachName ifAbsent: [ #() ]) copyWith: each) ] ].
	result addAll: (removedByName collect: [ :each | SPRemovedClass removed: each ]).
	
	^ result sorted: [ :a :b | a name <= b name ]
]

{ #category : #actions }
SPPackage >> createClassDiffsWith: anAncestor [
	"Answer a list of associations with the old class version as key and
	the new class as value. For a new class the old version will be nil,
	for a removed class the new version will be nil."

	| myClassRefs olderClassRefs diffs |
	
	myClassRefs := self classRefsByName.
	olderClassRefs := anAncestor classRefsByName.
	diffs := OrderedCollection new.
	
	olderClassRefs do: [ :each |
		| newRef |
		newRef := myClassRefs removeKey: each spiderClassName ifAbsent: [ nil ].
		(newRef isNil or: [ each isSameRef: newRef ])
			ifFalse: [ diffs add: each -> newRef ] ].
		
	myClassRefs do: [ :each |
		diffs add: nil -> each ].

	^ diffs
]

{ #category : #accessing }
SPPackage >> diffKey [
	^ self name
]

{ #category : #'gt-inspector-extension' }
SPPackage >> gtInspectorItemsIn: composite [
	^ (composite fastTable)
		title: 'Classes';
		display: [ self classRefs ];
		column: 'Name' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each name ];
		column: 'Type' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each spiderClass type ];
		column: 'Category' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each category ];
		selectionPopulate: #selection 
			entitled: 'Open key'
			with: [ :table | (table rawSelection collect: #key) gtInspectorInterestingObject ];
		beMultiple;
		send: [ :selection | 
			selection isNil 
			ifTrue:[nil]
			ifFalse:[ (selection size = 1) 
				ifTrue: [ selection anyOne value ] 
				ifFalse: [ selection collect: #value ] ]]

]

{ #category : #comparing }
SPPackage >> hash [ 

	^ packageHash hash
]

{ #category : #initialization }
SPPackage >> initPackageHash [

	packageHash := self calcPackageHash 
]

{ #category : #initialization }
SPPackage >> initWithName: aPackageName classRefs: aClassRefs comment: commentString [

	name := aPackageName.
	classRefs := aClassRefs sorted asArray.
	comment := commentString.
	
	self initPackageHash
]

{ #category : #accessing }
SPPackage >> name [
	^ name
]

{ #category : #accessing }
SPPackage >> packageHash [
	^ packageHash
]

{ #category : #accessing }
SPPackage >> packageHashLabel [
	^ (self packageHash last: 4) hex
]

{ #category : #printing }
SPPackage >> printHashSignatureOn: stream [

	stream 
		nextPutAll: name; lf.
		
	classRefs do: [ :each | each printHashSignatureOn: stream. stream lf ]
]

{ #category : #printing }
SPPackage >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	name printOn: aStream.
	aStream nextPut: $#.
	aStream nextPutAll: self packageHashLabel.
	aStream nextPut: $)
]

{ #category : #copying }
SPPackage >> withClass: aSPClass in: aCategory [
	"Answer a copy of the receiver with a new or updated class/category."

	| newClassRef newClassRefs replaced |
	
	replaced := false.
	newClassRef := SPPackageToClassRef spiderClass: aSPClass category: aCategory.
	newClassRefs := classRefs 
		collect: [ :each |
			each name = newClassRef name
				ifTrue: [ replaced := true. newClassRef ]
				ifFalse: [ each ] ].
	replaced
		ifFalse: [ newClassRefs := newClassRefs copyWith: newClassRef ].

	^ self class new initWithName: name classRefs: newClassRefs comment: comment
]
