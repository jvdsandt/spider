Class {
	#name : #SPPackageDiffTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #accessing }
SPPackageDiffTest >> spTestData [

	^ SPTestDataCore new
]

{ #category : #tests }
SPPackageDiffTest >> testPackageUpdated [

	| v1 v2 diffs |
	
	v1 := self spTestData createPackageAV1.
	v2 := self spTestData createPackageAV2.
	
	diffs := v2 compareClassesWith: v1.
	
	self assert: diffs size equals: 2.
	self assert: diffs first class equals: SPUpdatedClass.
	self assert: diffs first name equals: #ClassA.
	self assert: diffs last class equals: SPAddedClass.
	self assert: diffs last name equals: #Number.
	self assert: diffs last newObject isSpiderClassExtension.

]
