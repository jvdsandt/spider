Class {
	#name : #SPDiffUpdate,
	#superclass : #SPDiff,
	#instVars : [
		'newObject',
		'oldObject'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #'instance creation' }
SPDiffUpdate class >> old: anOldObject updated: aNewObject [

	^ self new initOld: anOldObject updated: aNewObject
]

{ #category : #initialization }
SPDiffUpdate >> initOld: anOldObject updated: aNewObject [

	oldObject := anOldObject.
	newObject := aNewObject
]

{ #category : #accessing }
SPDiffUpdate >> newObject [
	^ newObject
]

{ #category : #accessing }
SPDiffUpdate >> oldObject [
	^ oldObject
]
