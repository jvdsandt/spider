Class {
	#name : #SPPackageBuilderTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #running }
SPPackageBuilderTest >> createSampleClass: aName [

	^ SPClassBuilder new
			name: aName;
			build
]

{ #category : #running }
SPPackageBuilderTest >> createSampleClassExtension: aName [

	^ SPClassExtensionBuilder new
			name: aName;
			build
]

{ #category : #tests }
SPPackageBuilderTest >> testCategoryCleanup [

	| p |
	
	p := SPPackageBuilder new
		name: 'P';
		addClass: (self createSampleClass: #C1) category: 'P-Stuff';
		build.
		
	self assert: p name equals: 'P'.
	self assert: (p classRefNamed: #C1) category equals: 'Stuff'.

	p := SPPackageBuilder new
		name: 'P';
		addClass: (self createSampleClass: #C1) category: 'P-P-Stuff';
		build.
	self assert: (p classRefNamed: #C1) category equals: 'P-Stuff'.

]

{ #category : #tests }
SPPackageBuilderTest >> testDuplicateClassAndExtensionNameGivesError [

	self should: [ 
		SPPackageBuilder new
			name: 'P';
			addClass: (self createSampleClass: #C1) category: 'Stuff';
			addClassExtension: (self createSampleClassExtension: #C1);
			build ] raise: Error.
		
		
		
		

]

{ #category : #tests }
SPPackageBuilderTest >> testDuplicateClassNameGivesError [

	self should: [ 
		SPPackageBuilder new
			name: 'P';
			addClass: (self createSampleClass: #C1) category: 'Stuff';
			addClass: (self createSampleClass: #C1) category: 'Other';
			build ] raise: Error
		
		

]

{ #category : #tests }
SPPackageBuilderTest >> testDuplicateExtensionNameGivesError [

	self should: [ 
		SPPackageBuilder new
			name: 'P';
			addClassExtension: (self createSampleClassExtension: #C1);
			addClassExtension: (self createSampleClassExtension: #C1);
			build ] raise: Error.
		
		
		
		

]

{ #category : #tests }
SPPackageBuilderTest >> testEmptyPackage [

	| p |
	
	p := SPPackageBuilder new
		name: 'P';
		build.
		
	self assert: p name equals: 'P'.
]

{ #category : #tests }
SPPackageBuilderTest >> testStandard [

	| p |
	
	p := SPPackageBuilder new
		name: 'P';
		addClass: (self createSampleClass: #C1) category: 'Stuff';
		addClassExtension: (self createSampleClassExtension: #CE1);
		build.
		
	self assert: p name equals: 'P'.
	self assert: p classNames equals: #( C1 ).
	self assert: p classExtensionNames equals: #( CE1 ).
	
	self assert: (p classRefNamed: #C1) category equals: 'Stuff'.

]
