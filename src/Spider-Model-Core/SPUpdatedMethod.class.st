Class {
	#name : #SPUpdatedMethod,
	#superclass : #SPDiffUpdate,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPUpdatedMethod >> accept: aVisitor [
	aVisitor visitDiffUpdatedMethod: self
]

{ #category : #testing }
SPUpdatedMethod >> isClassSide [
	^ self newObject isClassSide
]

{ #category : #visiting }
SPUpdatedMethod >> name [
	^ self selector
]

{ #category : #accessing }
SPUpdatedMethod >> newCategory [

	^ self newObject category
]

{ #category : #accessing }
SPUpdatedMethod >> newMethod [

	^ self newObject method
]

{ #category : #accessing }
SPUpdatedMethod >> oldCategory [

	^ self oldObject category
]

{ #category : #accessing }
SPUpdatedMethod >> oldMethod [

	^ self oldObject method
]

{ #category : #accessing }
SPUpdatedMethod >> selector [

	^ self newObject selector
]
