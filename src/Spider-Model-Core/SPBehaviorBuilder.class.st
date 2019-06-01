Class {
	#name : #SPBehaviorBuilder,
	#superclass : #Object,
	#instVars : [
		'repo',
		'name',
		'comment',
		'methodRefs'
	],
	#category : #'Spider-Model-Core-Builders'
}

{ #category : #utilities }
SPBehaviorBuilder class >> cleanUpString: aString [

	| cleanString |

	aString isNil
		ifTrue: [ ^ nil ].
	cleanString := aString withUnixLineEndings trimBoth reject: [ :ch | ch asInteger = 0 ].
	^ cleanString isEmpty
			ifTrue: [ nil ]
			ifFalse: [ cleanString ]
]

{ #category : #adding }
SPBehaviorBuilder >> addClassMethod: spiderMethod category: catName [

	| existingRef |
	
	existingRef := methodRefs detect: [ :each | each isClassSide and: [ each selector = spiderMethod selector ] ]
			ifNone: [ nil ].
	existingRef notNil
		ifTrue: [ 
			spiderMethod = existingRef method
				ifTrue: [ ^ self ]
				ifFalse: [ self error: 'Duplicate selector on class side: ', spiderMethod selector asString ] ].
	
	methodRefs add: (SPGlorpClassToMethodRef classMethod: spiderMethod category: catName)
]

{ #category : #adding }
SPBehaviorBuilder >> addClassMethodSource: methodSource category: catName [

	^ self addClassMethod: (self buildMethodFromSource: methodSource) category: catName
]

{ #category : #adding }
SPBehaviorBuilder >> addCompiledMethod: aCompiledMethod [

	| method |
	
	method := self buildMethodFromCompiledMethod: aCompiledMethod.
	aCompiledMethod methodClass isMeta
		ifTrue: [ self addClassMethod: method category: aCompiledMethod protocol ]
		ifFalse: [ self addInstanceMethod: method category: aCompiledMethod protocol ]
]

{ #category : #adding }
SPBehaviorBuilder >> addInstanceMethod: spiderMethod category: catName [

	| existingRef |
	
	existingRef := methodRefs detect: [ :each | each isInstanceSide and: [ each selector = spiderMethod selector ] ]
		ifNone: [ nil ].
	existingRef notNil
		ifTrue: [ 
			spiderMethod = existingRef method
				ifTrue: [ ^ self ]
				ifFalse: [ self error: 'Duplicate selector on instance side: ', spiderMethod selector asString ] ].

	methodRefs add: (SPGlorpClassToMethodRef instanceMethod: spiderMethod category: catName)
]

{ #category : #adding }
SPBehaviorBuilder >> addInstanceMethodSource: methodSource category: catName [

	^ self addInstanceMethod: (self buildMethodFromSource: methodSource) category: catName
]

{ #category : #adding }
SPBehaviorBuilder >> addMCMethod: aMCMethod [

	| method |
	
	method := self buildMethodFromMCMethod: aMCMethod.
	aMCMethod classIsMeta
		ifTrue: [ self addClassMethod: method category: aMCMethod category ]
		ifFalse: [ self addInstanceMethod: method category: aMCMethod category ]
]

{ #category : #internal }
SPBehaviorBuilder >> buildMethodFromCompiledMethod: aCompiledMethod [

	^ self methodRepo newBuilder
		setCompiledMethod: aCompiledMethod;
		build
]

{ #category : #internal }
SPBehaviorBuilder >> buildMethodFromMCMethod: aMCMethodDef [

	^ self methodRepo newBuilder
		setMonticelloMethod: aMCMethodDef;
		build
]

{ #category : #internal }
SPBehaviorBuilder >> buildMethodFromSource: methodSource [

	^ self methodRepo newBuilder
		setSource: methodSource;
		build
]

{ #category : #accessing }
SPBehaviorBuilder >> comment [
	^ comment
]

{ #category : #accessing }
SPBehaviorBuilder >> comment: anObject [
	comment := anObject
]

{ #category : #initialization }
SPBehaviorBuilder >> initialize [

	super initialize.
	
	methodRefs := Set new.

]

{ #category : #accessing }
SPBehaviorBuilder >> methodRepo [

	^ self repo methodRepo
]

{ #category : #accessing }
SPBehaviorBuilder >> name [
	^ name
]

{ #category : #accessing }
SPBehaviorBuilder >> name: anObject [
	name := anObject
]

{ #category : #internal }
SPBehaviorBuilder >> privateImportMCMethods: aMCMethodDefColl [

	aMCMethodDefColl do: [ :eachMethod |
		self addMCMethod: eachMethod ]
]

{ #category : #accessing }
SPBehaviorBuilder >> repo [

	^ repo ifNil: [ repo := SPiderImageContext new classRepo ]
]

{ #category : #initialization }
SPBehaviorBuilder >> setRepo: aClasRepository [

	repo := aClasRepository 
]
