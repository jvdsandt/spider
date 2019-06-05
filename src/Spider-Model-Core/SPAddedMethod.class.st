Class {
	#name : #SPAddedMethod,
	#superclass : #SPDiffAdd,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #accessing }
SPAddedMethod >> selector [

	^ self newObject selector
]
