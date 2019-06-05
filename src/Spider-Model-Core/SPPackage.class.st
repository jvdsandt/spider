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

	| oldClassRefs result |
	
	oldClassRefs := olderPackage classRefsByName.
	result := OrderedCollection new.
	
	self classRefs do: [ :eachRef |
		| oldRef |
		oldRef := oldClassRefs removeKey: eachRef name ifAbsent: [ nil ].
		oldRef isNil
			ifTrue: [ result add: (SPAddedClass added: eachRef) ]
			ifFalse: [ 
				eachRef = oldRef
					ifFalse: [ result add: (SPUpdatedClass old: oldRef updated: eachRef) ] ] ].
	oldClassRefs do: [ :eachRef |
		result add: (SPRemovedClass removed: eachRef) ].
	^ result
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
	aStream nextPutAll: ((packageHash last: 4) hex first: 7).
	aStream nextPut: $)
]
