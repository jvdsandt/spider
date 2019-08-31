Class {
	#name : #SPRing2ClassTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Ring2-Tests'
}

{ #category : #tests }
SPRing2ClassTest >> testClassWithSlotVars [

	| spiderClass |
	
	spiderClass := SPGlorpClass className: #MyClass 
		classType: #normal
		superclassName: #Object
		variableRefs: (Array 
			with: (SPClassToVariableRef instanceVar: #myVar expression: '#myVar => ToManyRelationSlot inverse: #actors inClass: #SlotExampleMovie'))
		methodRefs: #()
		comment: nil.
		
	self assert: (spiderClass definitionIn: 'P1') equals: 'Object subclass: #MyClass
	slots: { #myVar => ToManyRelationSlot inverse: #actors inClass: #SlotExampleMovie }
	classVariables: {  }
	package: ''P1'''
]

{ #category : #tests }
SPRing2ClassTest >> testClassWithVars [

	| spiderClass |
	
	spiderClass := SPGlorpClass className: #MyClass 
		classType: #normal
		superclassName: #Object
		variableRefs: (Array 
			with: (SPClassToVariableRef instanceVar: #myVar)
			with: (SPClassToVariableRef classVar: #MyClassVar)
			with: (SPClassToVariableRef classInstanceVar: #myCInstVar)
			with: (SPClassToVariableRef poolVar: #MyPool))
		methodRefs: #()
		comment: nil.
		
	self assert: (spiderClass definitionIn: 'P-XYZ') equals: 'Object subclass: #MyClass
	instanceVariableNames: ''myVar''
	classVariableNames: ''MyClassVar''
	poolDictionaries: ''MyPool''
	package: ''P-XYZ'''.

	self assert: spiderClass classDefinition equals: 'MyClass class
	instanceVariableNames: ''myCInstVar'''
]

{ #category : #tests }
SPRing2ClassTest >> testPackageAV1 [

	| package ringClass expected |
	
	package := SPTestDataCore new createPackageAV1.
	
	ringClass := package ring2ClassNamed: #ClassA. 
	
	expected := 'Object subclass: #ClassA
	instanceVariableNames: ''''
	classVariableNames: ''''
	package: ''PackageA'''.
	self assert: expected equals: ringClass definition
]

{ #category : #tests }
SPRing2ClassTest >> testSmalltalkClass: aClass [

	| spiderClass package ringClass expected |
	
	spiderClass := SPClassBuilder new
		setClass: aClass;
		build.
	
	package := SPPackage name: aClass category 
		classRefs: (Array with: (SPPackageToClassRef spiderClass: spiderClass))
		comment: ''.
	
	ringClass := package ring2ClassNamed: aClass name. 
	
	expected := aClass definitionForNautilus.
	self assert: expected withSeparatorsCompacted equals: ringClass definition withSeparatorsCompacted.
	
	expected := aClass class definitionForNautilus.
	self assert: expected withSeparatorsCompacted equals: ringClass classDefinition withSeparatorsCompacted
]

{ #category : #tests }
SPRing2ClassTest >> testSmalltalkClassWithSlots [

	self testSmalltalkClass: SlotExamplePerson.
]

{ #category : #tests }
SPRing2ClassTest >> testSmalltalkClasses [

	self testSmalltalkClass: Boolean.
	self testSmalltalkClass: Array.
	self testSmalltalkClass: Point.
]

{ #category : #tests }
SPRing2ClassTest >> testSmalltalkTrait [

	self skip: 'Not working yet'.
	
	self testSmalltalkClass: SPTestTrait
]

{ #category : #tests }
SPRing2ClassTest >> testSmalltalkTraitUser [

	self testSmalltalkClass: SPTestTraitUser
]
