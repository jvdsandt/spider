Class {
	#name : #SPUpdatedPackage,
	#superclass : #SPDiffUpdate,
	#instVars : [
		'classDiffs'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPUpdatedPackage >> accept: aVisitor [
	aVisitor visitDiffUpdatedPackage: self
]

{ #category : #accessing }
SPUpdatedPackage >> classDiffs [

	^ classDiffs ifNil: [ classDiffs := self newObject compareClassesWithAll: self oldObjects ]
]
