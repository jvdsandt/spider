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

	| oldEdition newEdition diffs |
	
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
