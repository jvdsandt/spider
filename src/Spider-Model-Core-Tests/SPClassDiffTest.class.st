Class {
	#name : #SPClassDiffTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #running }
SPClassDiffTest >> createMethodFromSource: aString [

	^ SPMethodBuilder new
		setSource: aString;
		build
]

{ #category : #tests }
SPClassDiffTest >> testAddedMethod [

	| oldEdition newEdition diffs diff |
	
	oldEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		build.
		
	newEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addInstanceMethodSource: 'm2 ^234' category: 'resources';
		build.
	
	diffs := newEdition compareMethodsWith: oldEdition.
	self assert: diffs size equals: 1.
	diff := diffs first.
	self assert: diff class equals: SPAddedMethod.
	self assert: diff selector equals: #m2.
	
	"test the reverse"
	diffs := oldEdition compareMethodsWith: newEdition.
	self assert: diffs size equals: 1.
	diff := diffs first.
	self assert: diff class equals: SPRemovedMethod.
	self assert: diff selector equals: #m2.
	
	
]

{ #category : #tests }
SPClassDiffTest >> testEmptyClasses [

	| oldEdition newEdition |
	
	oldEdition := SPClassBuilder new
		name: #EmptyClass;
		build.
		
	newEdition := SPClassBuilder new
		name: #EmptyClass;
		build.
		
	self assert: (newEdition compareMethodsWith: oldEdition) isEmpty
]

{ #category : #tests }
SPClassDiffTest >> testInstanceToClassMethod [

	| oldEdition newEdition diffs |
	
	oldEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		build.
		
	newEdition := SPClassBuilder new
		name: #DummyClass;
		addClassMethodSource: 'm1 ^123' category: 'resources';
		build.
	
	diffs := newEdition compareMethodsWith: oldEdition.
	self assert: diffs size equals: 2.

]

{ #category : #tests }
SPClassDiffTest >> testMethodMerge [

	| oldEdition1 oldEdition2 newEdition diffs |
	
	oldEdition1 := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		build.
		
	oldEdition2 := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm2 ^234' category: 'resources';
		build.

	newEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addInstanceMethodSource: 'm2 ^234' category: 'resources';
		build.
	
	diffs := newEdition compareMethodsWithAll: (Array with: oldEdition1 with: oldEdition2).
	self assert: diffs isEmpty.
]

{ #category : #tests }
SPClassDiffTest >> testMethodMergeWithChange [

	| oldEdition1 oldEdition2 newEdition diffs diff |
	
	oldEdition1 := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		build.
		
	oldEdition2 := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm2 ^234' category: 'resources';
		build.

	newEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addInstanceMethodSource: 'm2 ^234' category: 'other';
		build.
	
	diffs := newEdition compareMethodsWithAll: (Array with: oldEdition1 with: oldEdition2).
	self assert: diffs size equals: 1.
	diff := diffs first.
	self assert: diff selector equals: #m2.
	self assert: diff oldObjects size equals: 1.
	self assert: diff oldObject equals: (oldEdition2 instanceMethodRefNamed: #m2).

]

{ #category : #tests }
SPClassDiffTest >> testMethodMergeWithChange2 [

	| oldEdition1 oldEdition2 newEdition diffs diff |
	
	oldEdition1 := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^111' category: 'resources';
		build.
		
	oldEdition2 := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^222' category: 'resources';
		build.

	newEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^333' category: 'resources';
		build.
	
	diffs := newEdition compareMethodsWithAll: (Array with: oldEdition1 with: oldEdition2).
	self assert: diffs size equals: 1.
	diff := diffs first.
	self assert: diff selector equals: #m1.
	self assert: diff oldObjects size equals: 2.
]

{ #category : #tests }
SPClassDiffTest >> testNoDiff [

	| oldEdition newEdition diffs |
	
	oldEdition := SPClassBuilder new
		name: #DummyClass;
		addClassMethodSource: 'm1 ^123' category: 'resources';
		build.
		
	newEdition := SPClassBuilder new
		name: #DummyClass;
		addClassMethodSource: 'm1 ^123' category: 'resources';
		build.
	
	diffs := newEdition compareMethodsWith: oldEdition.
	self assert: diffs isEmpty
]

{ #category : #tests }
SPClassDiffTest >> testUpdatedMethod [

	| oldEdition newEdition diffs diff |
	
	oldEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addInstanceMethodSource: 'm2 ^#one' category: 'resources';
		build.
		
	newEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addInstanceMethodSource: 'm2 ^#two' category: 'resources';
		build.
	
	diffs := newEdition compareMethodsWith: oldEdition.
	self assert: diffs size equals: 1.
	diff := diffs first.
	self assert: diff class equals: SPUpdatedMethod.
	self assert: diff selector equals: #m2.
	self assert: diff oldMethod equals: (self createMethodFromSource: 'm2 ^#one').
	self assert: diff newMethod equals: (self createMethodFromSource: 'm2 ^#two').

]

{ #category : #tests }
SPClassDiffTest >> testUpdatedMethodCategory [

	| oldEdition newEdition diffs diff |
	
	oldEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addInstanceMethodSource: 'm2 ^#one' category: 'resources';
		build.
		
	newEdition := SPClassBuilder new
		name: #DummyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addInstanceMethodSource: 'm2 ^#one' category: 'accessing';
		build.
	
	diffs := newEdition compareMethodsWith: oldEdition.
	self assert: diffs size equals: 1.
	diff := diffs first.
	self assert: diff class equals: SPUpdatedMethod.
	self assert: diff selector equals: #m2.
	self assert: diff oldCategory equals: 'resources'.
	self assert: diff newCategory equals: 'accessing'.
	self assert: diff oldMethod equals: diff newMethod.

]
