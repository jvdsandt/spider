Class {
	#name : #SPDiffRemove,
	#superclass : #SPDiff,
	#instVars : [
		'oldObject'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #'instance creation' }
SPDiffRemove class >> removed: anOldObject [

	^self new initOld: anOldObject
]

{ #category : #visiting }
SPDiffRemove >> accept: aVisitor [
	aVisitor visitDiffRemove: self
]

{ #category : #initialization }
SPDiffRemove >> initOld: anOldObject [

	oldObject := anOldObject
]

{ #category : #accessing }
SPDiffRemove >> name [
	^ self oldObject name
]

{ #category : #accessing }
SPDiffRemove >> oldObject [
	^ oldObject
]
