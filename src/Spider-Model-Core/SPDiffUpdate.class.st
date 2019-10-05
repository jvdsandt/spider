Class {
	#name : #SPDiffUpdate,
	#superclass : #SPDiff,
	#instVars : [
		'newObject',
		'oldObjects'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #'instance creation' }
SPDiffUpdate class >> old: oldObjects updated: aNewObject [

	^ self new initOld: oldObjects updated: aNewObject
]

{ #category : #visiting }
SPDiffUpdate >> accept: aVisitor [
	aVisitor visitDiffUpdate: self
]

{ #category : #initialization }
SPDiffUpdate >> initOld: anOldObjects updated: aNewObject [

	oldObjects := anOldObjects.
	newObject := aNewObject
]

{ #category : #visiting }
SPDiffUpdate >> name [
	^ self newObject name
]

{ #category : #accessing }
SPDiffUpdate >> newObject [
	^ newObject
]

{ #category : #accessing }
SPDiffUpdate >> oldObject [
	^ oldObjects first
]

{ #category : #accessing }
SPDiffUpdate >> oldObjects [
	^ oldObjects
]
