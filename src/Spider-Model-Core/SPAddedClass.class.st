Class {
	#name : #SPAddedClass,
	#superclass : #SPDiffAdd,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPAddedClass >> accept: aVisitor [
	aVisitor visitDiffAddedClass: self
]
