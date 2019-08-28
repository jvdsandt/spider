Extension { #name : #SPGlorpClass }

{ #category : #'*Spider-Model-Ring2' }
SPGlorpClass >> asRingMinimalDefinitionIn: anRGEnvironment [

	self isSpiderTrait 
		ifTrue: [ 
			^ anRGEnvironment backend
					definitionFor: self
					ifAbsentRegister: [ RGTrait named: self name parent: anRGEnvironment ] ].

	self isSpiderClass 
		ifTrue: [ 
			^ anRGEnvironment backend
					definitionFor: self
					ifAbsentRegister: [ RGClass named: self name parent: anRGEnvironment ] ].
				
	self error: 'Cannot create Ring definition'
]

{ #category : #'*Spider-Model-Ring2' }
SPGlorpClass >> ensureRingDefinitionIn: anRGEnvironment [

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
		def category: 'XYZ-Tests'.
"		def layout: (self ring2LayoutType parent: def).
"		metaclassDef layout: (RGFixedLayout parent: metaclassDef). 
		def comment: (
			(RGComment parent: def) 
				content: self comment;
"				author: (self authorForStamp: self commentStamp);
				time: (self timeForStamp: self commentStamp);
"				yourself).
		self instanceVarNames do: [ :each |
			def layout addSlot: (RGInstanceVariableSlot named: each parent: def layout) ].
		self classInstanceVarNames do: [ :each |
			metaclassDef layout addSlot: (RGInstanceVariableSlot named: each parent: metaclassDef layout) ].
		self classVarNames do: [ :each |
			def addClassVariable: (RGClassVariable named: each parent: def) ].
		self poolDictionaryNames do: [ :each |
			(RGPoolVariable named: each parent: def) ].
		def ]
]
