Class {
	#name : #SPAddedClass,
	#superclass : #SPDiffAdd,
	#instVars : [
		'methodDiffs'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPAddedClass >> accept: aVisitor [
	aVisitor visitDiffAddedClass: self
]

{ #category : #internal }
SPAddedClass >> calcMethodDiffs [

	^ self newSpiderClass methodRefs collect: [ :each | SPAddedMethod added: each ]
]

{ #category : #accessing }
SPAddedClass >> children [
	^ self methodDiffs
]

{ #category : #accessing }
SPAddedClass >> methodDiffs [

	^ methodDiffs ifNil: [ methodDiffs := self calcMethodDiffs ]
]

{ #category : #'instance creation' }
SPAddedClass >> newCategory [

	^ self newObject category
]

{ #category : #'instance creation' }
SPAddedClass >> newSpiderClass [ 

	^ self newObject spiderClass
]
