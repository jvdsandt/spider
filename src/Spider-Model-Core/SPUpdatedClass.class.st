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

{ #category : #testing }
SPUpdatedClass >> hasCommentDiff [

	^ self oldSpiderClass comment ~= self newSpiderClass comment
]

{ #category : #accessing }
SPUpdatedClass >> methodDiffs [

	^ methodDiffs ifNil: [ methodDiffs := self newSpiderClass compareMethodsWith: self oldSpiderClass ]
]

{ #category : #accessing }
SPUpdatedClass >> newCategory [

	^ self newObject category
]

{ #category : #accessing }
SPUpdatedClass >> newSpiderClass [

	^ self newObject spiderClass
]

{ #category : #accessing }
SPUpdatedClass >> oldCategory [

	^ self oldObject category
]

{ #category : #accessing }
SPUpdatedClass >> oldSpiderClass [

	^ self oldObject spiderClass
]
