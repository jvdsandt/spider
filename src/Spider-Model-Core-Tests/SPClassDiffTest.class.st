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
	self assert: diff oldObject method equals: (self createMethodFromSource: 'm2 ^#one').
	self assert: diff newObject method equals: (self createMethodFromSource: 'm2 ^#two').

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
	self assert: diff oldObject category equals: 'resources'.
	self assert: diff newObject category equals: 'accessing'.
	self assert: diff oldObject method equals: diff newObject method.

]
