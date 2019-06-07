Class {
	#name : #SPiderRingBackendTest,
	#superclass : #SPiderTestCase,
	#category : #'Spider-Model-Ring2'
}

{ #category : #tests }
SPiderRingBackendTest >> testClass [

	| env spClass rgClass |
	
	env := RGEnvironment new.
	env backend: (SPiderRingBackend for: env context: self context).
	
	spClass := SPClassBuilder new
		name: #EmptyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addClassMethodSource: 'm2 ^123' category: 'resources';
		build.

	rgClass := spClass asRingMinimalDefinitionIn: env.
	rgClass definition inspect
]

{ #category : #tests }
SPiderRingBackendTest >> testEnvironmentSetup [

	| env |
	
	env := RGEnvironment new.
	env backend: (SPiderRingBackend for: env context: self context).
	
	env ask behaviors

]

{ #category : #tests }
SPiderRingBackendTest >> testMethod [

	| spMethod |
	
	spMethod := self methodRepo newBuilder
		setSource: 'hello	self theMessage';
		build.

]
