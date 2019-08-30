Class {
	#name : #SPRing2Class,
	#superclass : #SPRing2Behavior,
	#category : #'Spider-Model-Ring2'
}

{ #category : #internal }
SPRing2Class >> ensureRingDefinitionIn: anRGEnvironment [

	^ anRGEnvironment backend definitionFor: self ifAbsentRegister: [
		| def metaclassDef |
		def := anRGEnvironment ensureClassNamed: self name asSymbol.
		metaclassDef := anRGEnvironment ensureClassNamed: (self name, ' class') asSymbol.
		def metaclass: metaclassDef.
		def traitComposition: (self traitCompositionFrom: self traitCompositionString parent: def).			
		metaclassDef traitComposition: (self traitCompositionFrom: self classTraitCompositionString parent: metaclassDef).			
		(self superclassName isNil or: [ self superclassName = #nil ])
			ifTrue: [ def superclass: def ]
			ifFalse: [ def superclass: (anRGEnvironment ensureClassNamed: self superclassName ) ].
		def category: self category.
		def layout: (self ring2LayoutType parent: def).
		metaclassDef layout: (RGFixedLayout parent: metaclassDef). 
		def comment: (
			(RGComment parent: def) 
				content: self comment;
				yourself).
		self spiderClass instanceVarRefs do: [ :each |
			def layout addSlot: (self ring2slotFor: each parent: def) ].
		self spiderClass classInstanceVarNames do: [ :each |
			metaclassDef layout addSlot: (RGInstanceVariableSlot named: each parent: metaclassDef layout) ].
		self spiderClass classVarNames do: [ :each |
			def addClassVariable: (RGClassVariable named: each parent: def) ].
		self spiderClass poolDictionaryNames do: [ :each |
			def addSharedPool: (RGPoolVariable named: each parent: def) ].
		def ]
]

{ #category : #internal }
SPRing2Class >> ring2LayoutType [

	^ (Dictionary newFrom: {	
		#compiledMethod -> RGCompiledMethodLayout. 
		#bytes -> RGByteLayout. 
		#immediate -> RGImmediateLayout. 
		#words -> RGWordLayout. 
		#week -> RGWeakLayout.
		#variable -> RGVariableLayout.
		#ephemeron -> RGEphemeronLayout.
		#normal -> RGFixedLayout.
		#weak -> RGWeakLayout.
	}) at: self spiderClass classType
]

{ #category : #internal }
SPRing2Class >> ring2slotFor: variableRef parent: def [

	| cleanExpression index |

	variableRef hasExpression 
		ifFalse: [ ^ RGInstanceVariableSlot named: variableRef variable parent: def layout ].

	cleanExpression := variableRef expression.
	index := cleanExpression indexOfSubCollection: '=>'.
	cleanExpression := index > 0
		ifTrue: [ (cleanExpression copyFrom: index+2 to: cleanExpression size) trimBoth ]
		ifFalse: [ cleanExpression ].

	^(RGUnknownSlot named: variableRef variable parent: def layout)
			expression: cleanExpression;
			yourself

]

{ #category : #accessing }
SPRing2Class >> superclassName [

	^ self spiderClass superclassName
]
