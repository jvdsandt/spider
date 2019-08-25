Class {
	#name : #SPRemovedMethod,
	#superclass : #SPDiffRemove,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPRemovedMethod >> accept: aVisitor [
	aVisitor visitDiffRemovedMethod: self
]

{ #category : #accessing }
SPRemovedMethod >> name [
	^ self selector
]

{ #category : #accessing }
SPRemovedMethod >> oldCategory [

	^ self oldObject category
]

{ #category : #accessing }
SPRemovedMethod >> oldMethod [

	^ self oldObject method
]

{ #category : #accessing }
SPRemovedMethod >> selector [

	^ self oldObject selector
]
