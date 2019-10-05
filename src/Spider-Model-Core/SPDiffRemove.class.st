Class {
	#name : #SPDiffRemove,
	#superclass : #SPDiff,
	#instVars : [
		'oldObjects'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #'instance creation' }
SPDiffRemove class >> removed: oldObjects [

	^self new initOld: oldObjects
]

{ #category : #visiting }
SPDiffRemove >> accept: aVisitor [
	aVisitor visitDiffRemove: self
]

{ #category : #initialization }
SPDiffRemove >> initOld: anOldObjects [

	oldObjects := anOldObjects
]

{ #category : #accessing }
SPDiffRemove >> name [
	^ self oldObject name
]

{ #category : #accessing }
SPDiffRemove >> oldObject [
	^ self oldObjects first
]

{ #category : #accessing }
SPDiffRemove >> oldObjects [
	^ oldObjects
]
