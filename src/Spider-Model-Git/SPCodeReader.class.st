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

{ #category : #'API-packages' }
SPCodeReader >> getPackageSnapshot: aPackageName [

	^ self getPackageSnapshot: aPackageName ifAbsent: [ self error: 'Package not found: ', aPackageName printString ]
]

{ #category : #'API-packages' }
SPCodeReader >> getPackageSnapshot: aPackageName ifAbsent: aBlock [

	self subclassResponsibility
]

{ #category : #initialization }
SPCodeReader >> on: aFileReference [

	fileReference := aFileReference
]
