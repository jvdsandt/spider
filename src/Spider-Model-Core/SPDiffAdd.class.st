Class {
	#name : #SPDiffAdd,
	#superclass : #SPDiff,
	#instVars : [
		'newObject'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #'instance creation' }
SPDiffAdd class >> added: aNewObject [

	^self new initNew: aNewObject
]

{ #category : #visiting }
SPDiffAdd >> accept: aVisitor [
	aVisitor visitDiffAdd: self
]

{ #category : #accessing }
SPDiffAdd >> iconName [
	^ #changeAdd
]

{ #category : #initialization }
SPDiffAdd >> initNew: aNewObject [

	newObject := aNewObject
]

{ #category : #accessing }
SPDiffAdd >> name [
	^ self newObject name
]

{ #category : #accessing }
SPDiffAdd >> newObject [
	^ newObject
]
