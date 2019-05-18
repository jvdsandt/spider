Class {
	#name : #SPPackageMCBuilder,
	#superclass : #SPPackageBuilder,
	#instVars : [
		'snapshot'
	],
	#category : #'Spider-Model-MC-Builders'
}

{ #category : #adding }
SPPackageMCBuilder >> addMCClass: aClassDefinition methods: aMCMethodDefs [

	| class |
	
	class := self classRepo newClassBuilder
		setMCClass: aClassDefinition methods: aMCMethodDefs;
		build.
		
	^ self addClass: class category: aClassDefinition category
]

{ #category : #adding }
SPPackageMCBuilder >> addMCClassExtension: aClassname methods: aMCMethodDefs [

	| classExtension |
	
	classExtension := self classRepo newClassExtensionBuilder 
		setMCClassname: aClassname methods: aMCMethodDefs;
		build.
		
	^ self addClassExtension: classExtension
]

{ #category : #adding }
SPPackageMCBuilder >> addMCClassTrait: aClassTraitDefinition methods: aMCMethodDefs [

	| spTrait |
	
	spTrait := self classRepo newClassBuilder
		setMCClassTrait: aClassTraitDefinition methods: aMCMethodDefs;
		build.
		
	^ self addClass: spTrait category: aClassTraitDefinition category
]

{ #category : #adding }
SPPackageMCBuilder >> addMCTrait: aTraitDefinition methods: aMCMethodDefs [

	| spTrait |
	
	spTrait := self classRepo newClassBuilder
		setMCTrait: aTraitDefinition methods: aMCMethodDefs;
		build.
		
	^ self addClass: spTrait category: aTraitDefinition category
]

{ #category : #building }
SPPackageMCBuilder >> build [ 

	| classDefinitions methodsByClass |
	
	classDefinitions := snapshot definitions select: [ :each | each isClassDefinition ].
	methodsByClass := (snapshot definitions select: [ :each | each isMethodDefinition ])
		groupedBy: [ :each | each className ].
		
	classDefinitions do: [ :each |
		| visitor |
		visitor := SPMonticelloClassDefinitionVisitor builder: self methods: methodsByClass.
		each accept: visitor ].

	methodsByClass keysAndValuesDo: [ :className :methods |
		self addMCClassExtension: className methods: methods ].
	
	^ super build
]

{ #category : #accessing }
SPPackageMCBuilder >> snapshot [
	^ snapshot
]

{ #category : #accessing }
SPPackageMCBuilder >> snapshot: mcSnapshot [

	snapshot := mcSnapshot.
]
