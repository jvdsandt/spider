Class {
	#name : #SPRing2Class,
	#superclass : #SPRing2Behavior,
	#category : #'Spider-Model-Ring2'
}

{ #category : #'as yet unclassified' }
SPRing2Class >> ensureRingDefinitionIn: anRGEnvironment [

	^ anRGEnvironment backend definitionFor: self ifAbsentRegister: [
		| def metaclassDef |
		def := anRGEnvironment ensureClassNamed: self name asSymbol.
		metaclassDef := anRGEnvironment ensureClassNamed: (self name, ' class') asSymbol.
		def metaclass: metaclassDef.
"		def traitComposition: (self traitCompositionFrom: self traitComposition parent: def).			
		metaclassDef traitComposition: (self traitCompositionFrom: self classTraitComposition parent: metaclassDef).			
"		(self superclassName isNil or: [ self superclassName = #nil ])
			ifTrue: [ def superclass: def ]
			ifFalse: [ def superclass: (anRGEnvironment ensureClassNamed: self superclassName ) ].
		def category: self category.
		def layout: (self ring2LayoutType parent: def).
		metaclassDef layout: (RGFixedLayout parent: metaclassDef). 
		def comment: (
			(RGComment parent: def) 
				content: self comment;
				yourself).
		self spiderClass instanceVarNames do: [ :each |
			def layout addSlot: (RGInstanceVariableSlot named: each parent: def layout) ].
		self spiderClass classInstanceVarNames do: [ :each |
			metaclassDef layout addSlot: (RGInstanceVariableSlot named: each parent: metaclassDef layout) ].
		self spiderClass classVarNames do: [ :each |
			def addClassVariable: (RGClassVariable named: each parent: def) ].
		self spiderClass poolDictionaryNames do: [ :each |
			(RGPoolVariable named: each parent: def) ].
		def ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #accessing }
SPRing2Class >> superclassName [

	^ self spiderClass superclassName
]
