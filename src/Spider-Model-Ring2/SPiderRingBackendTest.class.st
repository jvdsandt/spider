Class {
	#name : #SPiderRingBackendTest,
	#superclass : #SPiderTestCase,
	#category : #'Spider-Model-Ring2'
}

{ #category : #tests }
SPiderRingBackendTest >> testClass [

	| env spClass rgClass |
	
	env := RGEnvironment new.
	"env backend: (SPiderRingBackend for: env context: self context)."
	
	spClass := SPClassBuilder new
		superclassName: #Object;
		name: #EmptyClass;
		addInstanceVarSlot: (#instVarA asSlot);
		addClassInstanceVarSlot: (#devVarA asSlot);
		addClassVar: #MyClassVar;
		addPoolVar: #PoolA;
		addPoolVar: #PoolB;
		build.

	rgClass := env definitionFor: spClass.
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
