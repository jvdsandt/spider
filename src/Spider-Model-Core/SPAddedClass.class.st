Class {
	#name : #SPAddedClass,
	#superclass : #SPDiffAdd,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPAddedClass >> accept: aVisitor [
	aVisitor visitDiffAddedClass: self
]

{ #category : #'instance creation' }
SPAddedClass >> newCategory [

	^ self newObject category
]

{ #category : #'instance creation' }
SPAddedClass >> newSpiderClass [ 

	^ self newObject spiderClass
]
