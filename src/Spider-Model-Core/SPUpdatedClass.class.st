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

	^ methodDiffs ifNil: [ methodDiffs := self newSpiderClass compareMethodsWith: self oldSpiderClass ]
]

{ #category : #'as yet unclassified' }
SPUpdatedClass >> newSpiderClass [

	^ self newObject spiderClass
]

{ #category : #'as yet unclassified' }
SPUpdatedClass >> oldSpiderClass [

	^ self oldObject spiderClass
]
