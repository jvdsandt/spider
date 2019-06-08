Class {
	#name : #SPAddedPackage,
	#superclass : #SPDiffAdd,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPAddedPackage >> accept: aVisitor [
	aVisitor visitDiffAddedPackage: self
]
