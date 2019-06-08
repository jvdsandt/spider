Class {
	#name : #SPAddedMethod,
	#superclass : #SPDiffAdd,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPAddedMethod >> accept: aVisitor [
	aVisitor visitDiffAddedMethod: self
]

{ #category : #accessing }
SPAddedMethod >> selector [

	^ self newObject selector
]
