Class {
	#name : #SPRemovedClass,
	#superclass : #SPDiffRemove,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPRemovedClass >> accept: aVisitor [
	aVisitor visitDiffRemovedClass: self
]
