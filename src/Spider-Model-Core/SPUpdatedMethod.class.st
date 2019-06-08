Class {
	#name : #SPUpdatedMethod,
	#superclass : #SPDiffUpdate,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPUpdatedMethod >> accept: aVisitor [
	aVisitor visitDiffUpdatedMethod: self
]

{ #category : #accessing }
SPUpdatedMethod >> selector [

	^ self newObject selector
]
