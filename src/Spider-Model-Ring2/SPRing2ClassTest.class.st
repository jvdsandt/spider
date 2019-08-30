Class {
	#name : #SPRing2ClassTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Ring2'
}

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
SPRing2ClassTest >> testSmalltalkClasses [

	self testSmalltalkClass: Boolean.
	self testSmalltalkClass: Array.
	self testSmalltalkClass: Point.
]

{ #category : #tests }
SPRing2ClassTest >> testSmalltalkTrait [

	self testSmalltalkClass: SPTestTrait
]

{ #category : #tests }
SPRing2ClassTest >> testSmalltalkTraitUser [

	self testSmalltalkClass: SPTestTraitUser
]
