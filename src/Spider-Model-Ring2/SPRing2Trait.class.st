Class {
	#name : #SPRing2Trait,
	#superclass : #SPRing2Behavior,
	#category : #'Spider-Model-Ring2'
}

{ #category : #internal }
SPRing2Trait >> ensureRingDefinitionIn: anRGEnvironment [

	^ anRGEnvironment backend definitionFor: self ifAbsentRegister: [
		| def classTraitDef |
		def := anRGEnvironment ensureTraitNamed: self name asSymbol.
		classTraitDef := anRGEnvironment ensureMetaclassTraitNamed: (self name, ' classTrait') asSymbol.
		def classTrait: classTraitDef.
		classTraitDef baseTrait: def.
		def traitComposition: (self traitCompositionFrom: self spiderClass traitCompositionString parent: def).
		classTraitDef traitComposition: (
			self traitCompositionFrom: self spiderClass classTraitCompositionString parent: classTraitDef).	
		def category: self category.
		def comment: (
			(RGComment parent: def) 
				content: self comment;
				yourself).
		def]. 
	
]
