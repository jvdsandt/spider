Class {
	#name : #SPTestTraitUser,
	#superclass : #Object,
	#traits : 'SPTestTrait',
	#classTraits : 'SPTestTrait classTrait',
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #'as yet unclassified' }
SPTestTraitUser >> doStuff [

	^ self doTraitStuff
]
