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
SPPackageDiffTest >> testClassAndExtensionAreDifferent [

	| oldEdition newEdition diffs |
	
	
	oldEdition := SPPackageBuilder new
		name: 'P1';
		addClassExtension: (SPClassExtensionBuilder new
				name: #Dummy;
				addInstanceMethodSource: 'm1 ^123' category: 'resources';
				build);
		build.
		
	newEdition := SPPackageBuilder new
		name: 'P1';
		addClass: (SPClassBuilder new
				name: #Dummy;
				addInstanceMethodSource: 'm1 ^123' category: 'resources';
				build) category: '';
		build.

	diffs := newEdition compareClassesWith: oldEdition.
	self assert: diffs size equals: 2.
	self assert: diffs first class equals: SPAddedClass.
	self assert: diffs first newObject isSpiderClass.
	self assert: diffs last class equals: SPRemovedClass.
	self assert: diffs last oldObject isSpiderClassExtension.
	


]

{ #category : #tests }
SPPackageDiffTest >> testClassAndTraitAreDifferent [

	| oldEdition newEdition diffs |
	
	
	oldEdition := SPPackageBuilder new
		name: 'P1';
		addClass: (SPClassBuilder new
				name: #Dummy;
				addInstanceMethodSource: 'm1 ^123' category: 'resources';
				build) category: '';
		build.
		
	newEdition := SPPackageBuilder new
		name: 'P1';
		addClass: (SPClassBuilder new
				name: #Dummy;
				beTrait;
				addInstanceMethodSource: 'm1 ^123' category: 'resources';
				build) category: '';
		build.

	diffs := newEdition compareClassesWith: oldEdition.
	self assert: diffs size equals: 2.
	self assert: diffs first class equals: SPAddedClass.
	self assert: diffs first newObject isSpiderTrait.
	self assert: diffs last class equals: SPRemovedClass.
	self deny: diffs last oldObject isSpiderTrait.
	


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
