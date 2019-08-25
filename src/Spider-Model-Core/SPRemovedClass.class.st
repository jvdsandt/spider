Class {
	#name : #SPRemovedClass,
	#superclass : #SPDiffRemove,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPRemovedClass >> accept: aVisitor [
	aVisitor visitDiffRemovedClass: self
]

{ #category : #accessing }
SPRemovedClass >> oldCategory [

	^ self oldObject category
]

{ #category : #accessing }
SPRemovedClass >> oldSpiderClass [

	^ self oldObject spiderClass
]
