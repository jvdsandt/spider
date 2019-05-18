Class {
	#name : #SPGlorpPackage,
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
SPGlorpPackage class >> name: aPackageName classRefs: aClasses comment: commentString [

	^ self new initWithName: aPackageName classRefs: aClasses comment: commentString
]

{ #category : #initialization }
SPGlorpPackage >> calcPackageHash [

	| byteStream charStream |
	
	byteStream := WriteStream on: (ByteArray new: 800).
	charStream := ZnCharacterWriteStream on: byteStream encoding: ZnCharacterEncoder utf8.
	self printHashSignatureOn: charStream.
	^ SHA1 hashMessage: byteStream contents
]

{ #category : #accessing }
SPGlorpPackage >> classExtensionNamed: aName [

	^ (classRefs detect: [ :each | each isSpiderClassExtension and: [ each name = aName ] ]) spiderClass
]

{ #category : #accessing }
SPGlorpPackage >> classExtensionNames [
	^ self classExtensions collect: [ :each | each name ]
]

{ #category : #accessing }
SPGlorpPackage >> classExtensions [
	^ classRefs select: [ :each | each isSpiderClassExtension ]
]

{ #category : #accessing }
SPGlorpPackage >> classNamed: aName [

	^ (classRefs detect: [ :each | each name = aName and: [ each isSpiderClass ] ]) spiderClass
]

{ #category : #accessing }
SPGlorpPackage >> classNames [
	^ self classes collect: [ :each | each name ]
]

{ #category : #accessing }
SPGlorpPackage >> classRefNamed: aName [

	^ classRefs detect: [ :each | each name = aName ]
]

{ #category : #accessing }
SPGlorpPackage >> classRefs [
	^ classRefs
]

{ #category : #accessing }
SPGlorpPackage >> classRefsByName [
	^ self classRefs
			inject: Dictionary new
			into: [ :dict :each |
				dict 
					at: each spiderClassName put: each; 
					yourself ]
]

{ #category : #accessing }
SPGlorpPackage >> classes [
	^ classRefs select: [ :each | each isSpiderClass ]
]

{ #category : #accessing }
SPGlorpPackage >> comment [
	^ comment
]

{ #category : #actions }
SPGlorpPackage >> createClassDiffsWith: anAncestor [
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

{ #category : #initialization }
SPGlorpPackage >> initPackageHash [

	packageHash := self calcPackageHash 
]

{ #category : #initialization }
SPGlorpPackage >> initWithName: aPackageName classRefs: aClassRefs comment: commentString [

	name := aPackageName.
	classRefs := aClassRefs sorted asArray.
	comment := commentString.
	
	self initPackageHash
]

{ #category : #accessing }
SPGlorpPackage >> name [
	^ name
]

{ #category : #accessing }
SPGlorpPackage >> packageHash [
	^ packageHash
]

{ #category : #printing }
SPGlorpPackage >> printHashSignatureOn: stream [

	stream 
		nextPutAll: name; lf.
		
	classRefs do: [ :each | each printHashSignatureOn: stream. stream lf ]
]

{ #category : #printing }
SPGlorpPackage >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	name printOn: aStream.
	aStream nextPut: $#.
	aStream nextPutAll: ((packageHash last: 4) hex first: 7).
	aStream nextPut: $)
]