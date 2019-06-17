Class {
	#name : #SPDiffRenderer,
	#superclass : #SPDiffVisitor,
	#instVars : [
		'component',
		'canvas'
	],
	#category : #'Spider-Web-Core-Diff'
}

{ #category : #accessing }
SPDiffRenderer >> canvas [
	^ canvas
]

{ #category : #accessing }
SPDiffRenderer >> canvas: anObject [
	canvas := anObject
]

{ #category : #accessing }
SPDiffRenderer >> component [
	^ component
]

{ #category : #accessing }
SPDiffRenderer >> component: anObject [
	component := anObject
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffAddedClass: aDiff [
	self component renderAddedClass: aDiff on: self canvas
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffAddedMethod: aDiff [
	self component renderAddedMethod: aDiff on: self canvas
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffAddedPackage: aDiff [
	self component renderAddedPackage: aDiff on: self canvas
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffRemovedClass: aDiff [
	self component renderRemovedClass: aDiff on: self canvas
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffRemovedMethod: aDiff [
	self component renderRemovedMethod: aDiff on: self canvas
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffRemovedPackage: aDiff [
	self component renderRemovedPackage: aDiff on: self canvas
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffUpdatedClass: aDiff [
	self component renderUpdatedClass: aDiff on: self canvas
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffUpdatedMethod: aDiff [
	self component renderUpdatedMethod: aDiff on: self canvas
]

{ #category : #visiting }
SPDiffRenderer >> visitDiffUpdatedPackage: aDiff [
	self component renderUpdatedPackage: aDiff on: self canvas
]
