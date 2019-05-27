Class {
	#name : #SPCodeReader,
	#superclass : #Object,
	#instVars : [
		'fileReference'
	],
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'instance creation' }
SPCodeReader class >> on: aFileReference [

	^ self new on: aFileReference
]

{ #category : #initialization }
SPCodeReader >> on: aFileReference [

	fileReference := aFileReference
]
