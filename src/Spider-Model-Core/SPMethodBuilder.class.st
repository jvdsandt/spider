Class {
	#name : #SPMethodBuilder,
	#superclass : #Object,
	#instVars : [
		'repo',
		'source',
		'selector',
		'sourceBytes',
		'sourceHash',
		'messages',
		'variables'
	],
	#category : #'Spider-Model-Core-Builders'
}

{ #category : #utilities }
SPMethodBuilder class >> cleanUpSource: aString [

	^ aString withUnixLineEndings trimBoth reject: [ :ch | ch asInteger = 0 ]
]

{ #category : #internal }
SPMethodBuilder >> addPragma: aKeywordSelector arguments: anArgArray [

	| flags |
	
	flags := messages at: aKeywordSelector ifAbsent: [ 0 ].
	flags := flags bitOr: SPMethodToSelectorRef flagPragma.
	messages at: aKeywordSelector put: flags
]

{ #category : #internal }
SPMethodBuilder >> addSend: aSelector toSelf: toSelf toSuper: toSuper [

	| flags |
	
	flags := messages at: aSelector ifAbsent: [ 0 ].
	flags := flags bitOr: SPMethodToSelectorRef flagSend.
	toSelf 
		ifTrue: [ flags := flags bitOr: SPMethodToSelectorRef flagSelfSend ].
	toSuper 
		ifTrue: [ flags := flags bitOr: SPMethodToSelectorRef flagSuperSend ].
	messages at: aSelector put: flags
]

{ #category : #internal }
SPMethodBuilder >> addVariable: anIdentifier read: isRead write: isWritten [

	| flags varName |
	
	varName := anIdentifier asSymbol.
	flags := variables at: varName ifAbsent: [ 0 ].

	isRead 
		ifTrue: [ flags := flags bitOr: SPMethodToVariableRef flagRead ].
	isWritten 
		ifTrue: [ flags := flags bitOr: SPMethodToVariableRef flagWrite ].
	
	variables at: varName put: flags
]

{ #category : #actions }
SPMethodBuilder >> build [
	
	repo notNil
		ifTrue: [ 
			| method |
			method := repo selectMethodByHash: sourceHash ifAbsent: [ nil ].
			method notNil
				ifTrue: [ ^ method ] ].			

	self parseSource.
	
	^ SPMethod selector: selector 
			source: self source
			hash: self sourceHash
			selectorRefs: self createMethodToSelectorRefs 
			variableRefs: self createMethodToVariableRefs
]

{ #category : #internal }
SPMethodBuilder >> createMethodToSelectorRefs [

	| list |
	
	list := OrderedCollection new: variables size.
	messages keysAndValuesDo: [ :eachSelector :eachFlags |
		list add: (SPMethodToSelectorRef selector: eachSelector flags: eachFlags) ].
	^list asArray
]

{ #category : #internal }
SPMethodBuilder >> createMethodToVariableRefs [

	| list |
	
	list := OrderedCollection new: variables size.
	variables keysAndValuesDo: [ :eachName :eachFlags |
		list add: (SPMethodToVariableRef variable: eachName flags: eachFlags) ].
	^list asArray

]

{ #category : #initialization }
SPMethodBuilder >> initialize [ 

	super initialize.
	messages := Dictionary new.
	variables := Dictionary new
]

{ #category : #accessing }
SPMethodBuilder >> messages [
	^ messages
]

{ #category : #parsing }
SPMethodBuilder >> parseSource [

	self parseSource: source retry: true
]

{ #category : #parsing }
SPMethodBuilder >> parseSource: aSource retry: aBoolean [

	| tree |
	
	tree := RBParser parseFaultyMethod: aSource.
	tree isNil 
		ifTrue: [
			^aBoolean 
				ifTrue: [ self parseSource: (aSource readStream upTo: Character cr) retry: false ]
				ifFalse: [ self ] ].
	
	tree compilationContext: (CompilationContext default
		environment: SystemDictionary new;
		yourself).
	
	[ tree doSemanticAnalysis ] 
		on: OCUndeclaredVariableWarning do: [ :ex | 
			ex resume: (OCUndeclaredVariable new name: ex node name asSymbol) ].
	
	tree acceptVisitor: (SPMethodNodeVisitor newWithBuilder: self)
]

{ #category : #accessing }
SPMethodBuilder >> selector [
	^ selector
]

{ #category : #initialization }
SPMethodBuilder >> setCompiledMethod: aCM [

	self setSource: aCM sourceCode
]

{ #category : #internal }
SPMethodBuilder >> setImplements: aName [

	selector := aName asSymbol
]

{ #category : #initialization }
SPMethodBuilder >> setMonticelloMethod: aMCMethodDef [

	self setSource: aMCMethodDef source
]

{ #category : #initialization }
SPMethodBuilder >> setRepo: aMethodRepository [

	repo := aMethodRepository
]

{ #category : #initialization }
SPMethodBuilder >> setSource: aString [

	source := self class cleanUpSource: aString.
	sourceBytes := self utf8encoder encodeString: source.
	sourceHash := SHA1 hashMessage: sourceBytes.
]

{ #category : #accessing }
SPMethodBuilder >> source [
	^ source
]

{ #category : #accessing }
SPMethodBuilder >> sourceBytes [
	^ sourceBytes
]

{ #category : #accessing }
SPMethodBuilder >> sourceHash [
	^ sourceHash
]

{ #category : #resources }
SPMethodBuilder >> utf8encoder [

	^ ZnUTF8Encoder default
]

{ #category : #accessing }
SPMethodBuilder >> variables [
	^ variables
]
