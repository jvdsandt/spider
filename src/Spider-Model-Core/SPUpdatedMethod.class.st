Class {
	#name : #SPUpdatedMethod,
	#superclass : #SPDiffUpdate,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #accessing }
SPUpdatedMethod >> selector [

	^ self newObject selector
]
