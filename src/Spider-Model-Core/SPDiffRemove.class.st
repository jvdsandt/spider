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

{ #category : #initialization }
SPDiffRemove >> initOld: anOldObject [

	oldObject := anOldObject
]

{ #category : #accessing }
SPDiffRemove >> oldObject [
	^ oldObject
]
