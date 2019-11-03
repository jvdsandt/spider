Class {
	#name : #SPAddedMethod,
	#superclass : #SPDiffAdd,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPAddedMethod >> accept: aVisitor [
	aVisitor visitDiffAddedMethod: self
]

{ #category : #testing }
SPAddedMethod >> isClassSide [
	^ self newObject isClassSide 
]

{ #category : #accessing }
SPAddedMethod >> name [
	^ self selector
]

{ #category : #accessing }
SPAddedMethod >> newCategory [

	^ self newObject category
]

{ #category : #accessing }
SPAddedMethod >> newMethod [

	^ self newObject method
]

{ #category : #accessing }
SPAddedMethod >> selector [

	^ self newObject selector
]
