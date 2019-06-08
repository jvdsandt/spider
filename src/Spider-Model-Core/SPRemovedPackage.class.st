Class {
	#name : #SPRemovedPackage,
	#superclass : #SPDiffRemove,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPRemovedPackage >> accept: aVisitor [
	aVisitor visitDiffRemovedPackage: self
]
