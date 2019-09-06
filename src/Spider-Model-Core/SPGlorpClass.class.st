Class {
	#name : #SPGlorpClass,
	#superclass : #SPGlorpNode,
	#instVars : [
		'type',
		'name',
		'comment',
		'classHash',
		'classType',
		'superclassName',
		'methodRefs',
		'variableRefs',
		'traitCompositionString',
		'classTraitCompositionString'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPGlorpClass class >> className: aName classType: aClassType superclassName: aSuperName variableRefs: aVarRefs methodRefs: aMethodRefs comment: aCommentString [

	^ self className: aName 
			classType: aClassType
			superclassName: aSuperName 
			variableRefs: aVarRefs 
			methodRefs: aMethodRefs
			traitComposition: nil 
			classTraitComposition: nil
			comment: aCommentString

]

{ #category : #'instance creation' }
SPGlorpClass class >> className: aName classType: aClassType superclassName: aSuperName variableRefs: aVarRefs methodRefs: aMethodRefs traitComposition: aTraitComp classTraitComposition: aClassTraitComp comment: aCommentString [

	^ self type: self classType 
			name: aName 
			classType: aClassType
			superclassName: aSuperName 
			variableRefs: aVarRefs 
			methodRefs: aMethodRefs
			traitComposition: aTraitComp 
			classTraitComposition: aClassTraitComp
			comment: aCommentString

]

{ #category : #constants }
SPGlorpClass class >> classType [

	^ 40
]

{ #category : #'instance creation' }
SPGlorpClass class >> extensionName: aName methodRefs: aMethodRefs comment: commentString [

	^ self type: self extensionType
			name: aName
			classType: nil
			superclassName: nil
			variableRefs: #()
			methodRefs: aMethodRefs
			traitComposition: nil 
			classTraitComposition: nil
			comment: commentString
]

{ #category : #constants }
SPGlorpClass class >> extensionType [

	^ 41
]

{ #category : #'instance creation' }
SPGlorpClass class >> traitName: aName variableRefs: aVarRefs methodRefs: aMethodRefs traitComposition: aTraitComp classTraitComposition: aClassTraitComp comment: aCommentString [

	^ self type: self traitType 
			name: aName 
			classType: nil
			superclassName: nil 
			variableRefs: aVarRefs
			methodRefs: aMethodRefs
			traitComposition: aTraitComp 
			classTraitComposition: aClassTraitComp
			comment: aCommentString
]

{ #category : #constants }
SPGlorpClass class >> traitType [

	^ 42
]

{ #category : #'instance creation' }
SPGlorpClass class >> type: aType name: aName classType: aClassType superclassName: aSuperName variableRefs: varRefs methodRefs: methRefs traitComposition: aTraitComp classTraitComposition: aClassTraitComp comment: aComment [

	^ self new initType: aType
			name: aName 
			classType: aClassType 
			superclassName: aSuperName 
			variableRefs: varRefs 
			methodRefs: methRefs
			traitComposition: aTraitComp 
			classTraitComposition: aClassTraitComp
			comment: aComment
]

{ #category : #comparing }
SPGlorpClass >> <= other [

	^ self name <= other name
]

{ #category : #comparing }
SPGlorpClass >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ name = other name and: [ self classHash = other classHash ]
]

{ #category : #initialization }
SPGlorpClass >> calcClassHash [

	| byteStream charStream |
	
	byteStream := WriteStream on: (ByteArray new: 800).
	charStream := ZnCharacterWriteStream on: byteStream encoding: ZnCharacterEncoder utf8.
	self printHashSignatureOn: charStream.
	^ SHA1 hashMessage: byteStream contents
]

{ #category : #accessing }
SPGlorpClass >> classCategories [

	^ (self methodRefs 
			inject: Set new
			into: [ :coll :each | 
				(each isClassSide and: [ each category notNil ])
					ifTrue: [ coll add: each category ].
				coll ]) sorted
]

{ #category : #accessing }
SPGlorpClass >> classDefinition [ 
	
	^ self classDefinitionIn: nil

]

{ #category : #accessing }
SPGlorpClass >> classDefinitionIn: aCategory [
	"Answer the defining code for the metaclass"

	self isSpiderClassExtension 
		ifTrue: [ ^ '' ].
		
	^ (self ring2ClassIn: (aCategory ifNil: [ '' ])) classDefinition
		

]

{ #category : #accessing }
SPGlorpClass >> classHash [
	^ classHash
]

{ #category : #accessing }
SPGlorpClass >> classInstanceVarNames [

	^ variableRefs select: [ :each | each isClassInstanceVar ] thenCollect: [ :each | each variable ]
]

{ #category : #accessing }
SPGlorpClass >> classMethodRefNamed: aSymbol [

	^ self methodRefs detect: [ :each | each isClassSide and: [ each selector = aSymbol ] ]
]

{ #category : #accessing }
SPGlorpClass >> classMethodRefs [

	^ self methodRefs select: [ :each | each isClassSide ]
]

{ #category : #accessing }
SPGlorpClass >> classMethodRefsBySelector [

	^ self classMethodRefs 
		inject: Dictionary new
		into: [ :dict :each |
			dict
				at: each selector put: each;
				yourself ]
]

{ #category : #accessing }
SPGlorpClass >> classMethods [

	^ self classMethodRefs collect: [ :each | each method ]
]

{ #category : #accessing }
SPGlorpClass >> classSelectors [

	^ self classMethodRefs collect: [ :each | each selector ]
]

{ #category : #accessing }
SPGlorpClass >> classTraitCompositionString [

	^ classTraitCompositionString
]

{ #category : #accessing }
SPGlorpClass >> classType [
	^ classType
]

{ #category : #accessing }
SPGlorpClass >> classVarNames [

	^ variableRefs select: [ :each | each isClassVar ] thenCollect: [ :each | each variable ]
]

{ #category : #accessing }
SPGlorpClass >> classVarRefNamed: aSymbol [

	^ variableRefs detect: [ :each | each isClassVar and: [ each variable = aSymbol ] ]
]

{ #category : #accessing }
SPGlorpClass >> comment [
	^ comment
]

{ #category : #comparing }
SPGlorpClass >> compareMethodsWith: olderClass [

	| oldClassMethodRefs oldInstanceMethodRefs result |
	
	oldClassMethodRefs := olderClass classMethodRefsBySelector.
	oldInstanceMethodRefs := olderClass instanceMethodRefsBySelector.
	result := OrderedCollection new.
	
	self methodRefs do: [ :eachRef |
		| oldRef |
		oldRef := eachRef isClassSide 
			ifTrue: [ oldClassMethodRefs removeKey: eachRef selector ifAbsent: [ nil ] ]
			ifFalse: [ oldInstanceMethodRefs removeKey: eachRef selector ifAbsent: [ nil ] ].
		oldRef isNil
			ifTrue: [ result add: (SPAddedMethod added: eachRef) ]
			ifFalse: [ 
				eachRef = oldRef
					ifFalse: [ result add: (SPUpdatedMethod old: oldRef updated: eachRef) ] ] ].
	oldClassMethodRefs do: [ :eachRef |
		result add: (SPRemovedMethod removed: eachRef) ].
	oldInstanceMethodRefs do: [ :eachRef |
		result add: (SPRemovedMethod removed: eachRef) ].
	^ result
]

{ #category : #actions }
SPGlorpClass >> createClassMethodDiffsWith: olderClass [
	"Answer a list of associations with the old method version as key and
	the new version as value. For a new method the old version will be nil,
	for a removed method the new version will be nil."

	| myMethods olderMethods diffs |
	
	myMethods := self classMethodRefsBySelector.
	olderMethods := olderClass classMethodRefsBySelector.
	diffs := OrderedCollection new.
	
	olderMethods do: [ :each |
		| newRef |
		newRef := myMethods removeKey: each selector ifAbsent: [ nil ].
		(each isSameRef: newRef)
			ifFalse: [ diffs add: each -> newRef ] ].
	myMethods do: [ :each |
		diffs add: nil -> each ].

	^ diffs
]

{ #category : #actions }
SPGlorpClass >> createInstanceMethodDiffsWith: olderClass [
	"Answer a list of associations with the old method version as key and
	the new version as value. For a new method the old version will be nil,
	for a removed method the new version will be nil."

	| myMethods olderMethods diffs |
	
	myMethods := self instanceMethodRefsBySelector.
	olderMethods := olderClass instanceMethodRefsBySelector.
	diffs := OrderedCollection new.
	
	olderMethods do: [ :each |
		| newRef |
		newRef := myMethods removeKey: each selector ifAbsent: [ nil ].
		(each isSameRef: newRef)
			ifFalse: [ diffs add: each -> newRef ] ].
	myMethods do: [ :each |
		diffs add: nil -> each ].

	^ diffs
]

{ #category : #accessing }
SPGlorpClass >> definition [ 
	
	^ self definitionIn: nil

]

{ #category : #accessing }
SPGlorpClass >> definitionIn: aCategory [
	"Answer the defining code for this class"

	self isSpiderClassExtension 
		ifTrue: [ ^ '' ].
		
	^ (self ring2ClassIn: (aCategory ifNil: [ '' ])) definition	
]

{ #category : #comparing }
SPGlorpClass >> hash [ 

	^ classHash hash
]

{ #category : #accessing }
SPGlorpClass >> hashSignature [

	^ String streamContents: [ :s | self printHashSignatureOn: s ]
]

{ #category : #initialization }
SPGlorpClass >> initClassHash [

	classHash := self calcClassHash.
]

{ #category : #initialization }
SPGlorpClass >> initType: aType name: aName classType: aClassType superclassName: aSuperName variableRefs: varRefs methodRefs: methRefs traitComposition: aTraitComp classTraitComposition: aClassTraitComp comment: aComment [

	type := aType.
	name := aName.
	classType := aClassType.
	superclassName := aSuperName.
	variableRefs := varRefs asArray.
	methodRefs := methRefs asArray.
	traitCompositionString := aTraitComp.
	classTraitCompositionString := aClassTraitComp.
	comment := aComment.

	self initClassHash.
]

{ #category : #accessing }
SPGlorpClass >> instanceCategories [

	^ (self methodRefs 
			inject: Set new
			into: [ :coll :each | 
				(each isInstanceSide and: [ each category notNil ])
					ifTrue: [ coll add: each category ].
				coll ]) sorted
]

{ #category : #accessing }
SPGlorpClass >> instanceMethodRefNamed: aSymbol [

	^ self methodRefs detect: [ :each | each isInstanceSide and: [ each selector = aSymbol ] ]
]

{ #category : #accessing }
SPGlorpClass >> instanceMethodRefs [

	^ self methodRefs select: [ :each | each isInstanceSide ]
]

{ #category : #accessing }
SPGlorpClass >> instanceMethodRefsBySelector [

	^ self instanceMethodRefs 
		inject: Dictionary new
		into: [ :dict :each |
			dict
				at: each selector put: each;
				yourself ]
]

{ #category : #accessing }
SPGlorpClass >> instanceMethods [

	^ self instanceMethodRefs collect: [ :each | each method ]
]

{ #category : #accessing }
SPGlorpClass >> instanceSelectors [

	^ self instanceMethodRefs collect: [ :each | each selector ]
]

{ #category : #accessing }
SPGlorpClass >> instanceVarNames [

	^ variableRefs select: [ :each | each isInstanceVar ] thenCollect: [ :each | each variable ]
]

{ #category : #accessing }
SPGlorpClass >> instanceVarRefNamed: aSymbol [

	^ variableRefs detect: [ :each | each isInstanceVar and: [ each variable = aSymbol ] ]
]

{ #category : #accessing }
SPGlorpClass >> instanceVarRefs [

	^ variableRefs select: [ :each | each isInstanceVar ]
]

{ #category : #testing }
SPGlorpClass >> isSpiderClass [
	"A Trait is also a class"
	
	^ type = self class classType or: [ type = self class traitType ]
]

{ #category : #testing }
SPGlorpClass >> isSpiderClassExtension [ 

	^ self type = self class extensionType
]

{ #category : #testing }
SPGlorpClass >> isSpiderTrait [

	^ self type = self class traitType
]

{ #category : #accessing }
SPGlorpClass >> methodRefs [
	^ methodRefs
]

{ #category : #accessing }
SPGlorpClass >> name [
	^ name
]

{ #category : #accessing }
SPGlorpClass >> poolDictionaryNames [  
	^ variableRefs select: [ :each | each isPoolVar ] thenCollect: [ :each | each variable ]
]

{ #category : #printing }
SPGlorpClass >> printHashSignatureOn: stream [

	stream 
		nextPutAll: name; lf;
		nextPutAll: (superclassName ifNil: [ '' ]); lf;
		print: type; space; nextPutAll: (classType ifNil: [ '' ]); lf.

	traitCompositionString notNil 
		ifTrue: [ stream nextPutAll: traitCompositionString; lf ].
	classTraitCompositionString notNil
		ifTrue: [ stream nextPutAll: classTraitCompositionString; lf ].
		
	stream lf.
	variableRefs sorted do: [ :each | each printHashSignatureOn: stream. stream lf ].
		
	stream lf.
	methodRefs sorted do: [ :each | each printHashSignatureOn: stream. stream lf ].
	
	comment notNil
		ifTrue: [ stream nextPutAll: comment; lf ].
]

{ #category : #printing }
SPGlorpClass >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $[.
	name printOn: aStream.
	aStream nextPut: $#.
	aStream nextPutAll: (self classHash last: 3) hex.
	aStream nextPut: $]
	
	
]

{ #category : #accessing }
SPGlorpClass >> superclassName [
	^ superclassName
]

{ #category : #accessing }
SPGlorpClass >> traitCompositionString [

	^ traitCompositionString
]

{ #category : #accessing }
SPGlorpClass >> type [
	^ type
]

{ #category : #accessing }
SPGlorpClass >> typeName [
	
	self isSpiderClassExtension 
		ifTrue: [ ^ #extension ].
	self isSpiderTrait 
		ifTrue: [ ^ #trait ].
	self isSpiderClass 
		ifTrue: [ ^ #class ].
	^ nil
]

{ #category : #accessing }
SPGlorpClass >> variableRefs [
	^ variableRefs
]

{ #category : #copying }
SPGlorpClass >> withClassMethod: aSPMethod in: aCategory [
	"Answer a copy of the receiver with a new or updated class method."

	^ self withMethodRef: (SPClassToMethodRef classMethod: aSPMethod category: aCategory)
]

{ #category : #copying }
SPGlorpClass >> withInstanceMethod: aSPMethod in: aCategory [
	"Answer a copy of the receiver with a new or updated instance method."

	^ self withMethodRef: (SPClassToMethodRef instanceMethod: aSPMethod category: aCategory)
]

{ #category : #copying }
SPGlorpClass >> withMethodRef: newMethodRef [
	"Answer a copy of the receiver with a new or updated method or category."

	| newMethodRefs replaced |
	
	replaced := false.
	newMethodRefs := methodRefs 
		collect: [ :each |
			(each type = newMethodRef type and: [ each selector = newMethodRef selector ])
				ifTrue: [ replaced := true. newMethodRef ]
				ifFalse: [ each ] ].
	replaced
		ifFalse: [ newMethodRefs := newMethodRefs copyWith: newMethodRef ].

	^ self class new initType: type 
			name: name 
			classType: classType 
			superclassName: superclassName 
			variableRefs: variableRefs 
			methodRefs: newMethodRefs  
			traitComposition: traitCompositionString  
			classTraitComposition: classTraitCompositionString  
			comment: comment
]
