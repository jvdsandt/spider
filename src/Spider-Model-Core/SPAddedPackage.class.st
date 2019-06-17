Class {
	#name : #SPAddedPackage,
	#superclass : #SPDiffAdd,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPAddedPackage >> accept: aVisitor [
	aVisitor visitDiffAddedPackage: self
]

{ #category : #accessing }
SPAddedPackage >> classDiffs [

	^ self newObject classes collect: [ :each | SPAddedClass added: each ]
]
