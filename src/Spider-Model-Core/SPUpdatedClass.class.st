Class {
	#name : #SPUpdatedClass,
	#superclass : #SPDiffUpdate,
	#instVars : [
		'methodDiffs'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPUpdatedClass >> accept: aVisitor [
	aVisitor visitDiffUpdatedClass: self
]

{ #category : #accessing }
SPUpdatedClass >> methodDiffs [

	^ methodDiffs ifNil: [ methodDiffs := self newObject compareMethodsWith: self oldObject ]
]
