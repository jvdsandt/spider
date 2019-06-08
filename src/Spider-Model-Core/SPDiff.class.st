Class {
	#name : #SPDiff,
	#superclass : #Object,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPDiff >> accept: aVisitor [
	aVisitor visitDiff: self
]

{ #category : #accessing }
SPDiff >> newObject [
	^ nil
]

{ #category : #accessing }
SPDiff >> oldObject [
	^ nil
]
