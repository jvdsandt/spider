Class {
	#name : #SPClassBuilder,
	#superclass : #SPBehaviorBuilder,
	#instVars : [
		'superclassName',
		'variableRefs',
		'classType',
		'traitCompositionString',
		'classTraitCompositionString',
		'classIsTrait'
	],
	#category : #'Spider-Model-Core-Builders'
}

{ #category : #adding }
SPClassBuilder >> addClassInstanceVarSlot: aSlot [

	| expression |

	expression := aSlot definitionString.

	variableRefs add: (
		SPGlorpClassToVariableRef type: SPGlorpClassToVariableRef classInstanceVarType 
			variable: aSlot name
			expression: (aSlot name printString = expression ifTrue: [ nil ] ifFalse: [ expression ]))

]

{ #category : #adding }
SPClassBuilder >> addClassVar: aVarName [

	variableRefs add: (SPGlorpClassToVariableRef classVar: aVarName)
]

{ #category : #adding }
SPClassBuilder >> addInstanceVarSlot: aSlot [

	| expression |

	expression := aSlot definitionString.

	variableRefs add: (
		SPGlorpClassToVariableRef type: SPGlorpClassToVariableRef instanceVarType 
			variable: aSlot name
			expression: (aSlot name printString = expression ifTrue: [ nil ] ifFalse: [ expression ]))

]

{ #category : #adding }
SPClassBuilder >> addMCVar: aVarName type: aVarType [

	variableRefs add: (
		SPGlorpClassToVariableRef type: aVarType variable: aVarName)
]

{ #category : #adding }
SPClassBuilder >> addPoolVar: aVarName [

	variableRefs add: (SPGlorpClassToVariableRef poolVar: aVarName)
]

{ #category : #building }
SPClassBuilder >> build [
	"Build the Spider class. If exactly the same class is already present in
	the repository than we reuse this existing Spider ckass."

	| newClass existingClass |
	
	newClass := classIsTrait 
		ifTrue: [ 
			SPGlorpClass traitName: name 
					variableRefs: variableRefs 
					methodRefs: methodRefs 
					traitComposition: (self cleanupTraitCompositionString: traitCompositionString)
					classTraitComposition: (self cleanupTraitCompositionString: classTraitCompositionString)
					comment: comment ]
		ifFalse: [
			SPGlorpClass className: name
				classType: classType
				superclassName: superclassName
				variableRefs: variableRefs 
				methodRefs: methodRefs 
				traitComposition: (self cleanupTraitCompositionString: traitCompositionString)
				classTraitComposition: (self cleanupTraitCompositionString: classTraitCompositionString)
				comment: comment ].
			
	existingClass := self repo getClassByHash: newClass classHash ifAbsent: [ nil ].
	^ existingClass ifNil: [ newClass ]
]

{ #category : #internal }
SPClassBuilder >> cleanupTraitCompositionString: aString [

	^ (aString isNil or: [ (aString reject: [ :ch | ch isSeparator ]) = '{}' ])
		ifTrue: [ nil ]
		ifFalse: [ aString trimBoth ]
]

{ #category : #internal }
SPClassBuilder >> includeCompiledMethod: aCompiledMethod [

	^aCompiledMethod isFromTrait not and: [ 
		aCompiledMethod protocol isNil or: [ 
			(aCompiledMethod protocol beginsWith: '*') not ] ]

]

{ #category : #initialization }
SPClassBuilder >> initialize [

	super initialize.
	
	variableRefs := OrderedCollection new.
	
	superclassName := #Object.
	classType := #normal.
	classIsTrait := false
]

{ #category : #initialization }
SPClassBuilder >> setClass: aClass [

	self setClass: aClass
			instMethods: (aClass methods select: [ :cm | self includeCompiledMethod: cm ])
			classMethods: (aClass class methods select: [ :cm | self includeCompiledMethod: cm ])
]

{ #category : #initialization }
SPClassBuilder >> setClass: aClass instMethods: instMethods classMethods: classMethods [

	name := aClass name.
	classType := aClass typeOfClass.
	classIsTrait := aClass isTrait.
	superclassName := aClass superclass ifNotNil: [ :c | c name ].
	comment := self class cleanUpString: (aClass organization classComment	asString).
		
	aClass localSlots do: [ :each | self addInstanceVarSlot: each ].
	aClass classVarNames do: [ :each | self addClassVar: each ].
	aClass class localSlots do: [ :each | self addClassInstanceVarSlot: each ].
	aClass sharedPoolNames do: [ :each | self addPoolVar: each ].
		
	traitCompositionString := aClass traitCompositionString.
	classTraitCompositionString := aClass class traitCompositionString.
	
	instMethods do: [ :each | self addCompiledMethod: each ].
		
	classMethods do: [ :each | self addCompiledMethod: each ].
]

{ #category : #initialization }
SPClassBuilder >> setMCClass: aMCClassDef methods: aMCMethodDefs [

	name := aMCClassDef className.
	classType := aMCClassDef type.
	superclassName := aMCClassDef superclassName.
	comment := aMCClassDef comment.

	traitCompositionString := aMCClassDef traitCompositionString.
	classTraitCompositionString := aMCClassDef classTraitCompositionString.

	"Make sure that the variables collection is initialized."
	aMCClassDef variables.
	
	aMCClassDef instVarNames do: [ :each | self addMCVar: each type: SPGlorpClassToVariableRef instanceVarType ].
	aMCClassDef classVarNames do: [ :each | self addMCVar: each type: SPGlorpClassToVariableRef classVarType ].
	aMCClassDef classInstVarNames do: [ :each | self addMCVar: each type: SPGlorpClassToVariableRef classInstanceVarType ].
	aMCClassDef poolDictionaries do: [ :each | self addMCVar: each type: SPGlorpClassToVariableRef poolVarType ].
	
	self privateImportMCMethods: aMCMethodDefs
]

{ #category : #initialization }
SPClassBuilder >> setMCClassTrait: aMCClassTraitDef methods: aMCMethodDefs [

	classIsTrait := true.
	name := aMCClassTraitDef className.
	traitCompositionString := aMCClassTraitDef classTraitComposition 
]

{ #category : #initialization }
SPClassBuilder >> setMCTrait: aMCTraitDef methods: aMCMethodDefs [

	classIsTrait := true.
	self setMCClass: aMCTraitDef methods: aMCMethodDefs

]

{ #category : #initialization }
SPClassBuilder >> setTonelFileReference: aFileRef [
	"Initialize this build using a class source file in Tonel format."

	| mcDefs classDefs methodDefs |
	
	mcDefs := aFileRef readStreamDo: [ :s | TonelParser parseStream: s ].
	
	classDefs := mcDefs select: [ :each | each isClassDefinition ].
	classDefs size = 1
		ifFalse: [ self error: 'A single classdef expected' ].
		
	methodDefs := mcDefs select: [ :each | each isMethodDefinition ].
	
	classDefs first isTraitDefinition 
		ifTrue: [ self setMCTrait: classDefs first methods: methodDefs ]
		ifFalse: [ self setMCClass: classDefs first methods: methodDefs ]
]

{ #category : #accessing }
SPClassBuilder >> superclassName [
	^ superclassName
]

{ #category : #accessing }
SPClassBuilder >> superclassName: anObject [
	superclassName := anObject
]