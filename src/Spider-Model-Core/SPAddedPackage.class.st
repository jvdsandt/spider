Class {
	#name : #SPAddedPackage,
	#superclass : #SPDiffAdd,
	#instVars : [
		'classDiffs'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPAddedPackage >> accept: aVisitor [
	aVisitor visitDiffAddedPackage: self
]

{ #category : #internal }
SPAddedPackage >> calcClassDiffs [

	^ self newObject classRefs collect: [ :each | SPAddedClass added: each ]
]

{ #category : #accessing }
SPAddedPackage >> children [
	^ self classDiffs
]

{ #category : #accessing }
SPAddedPackage >> classDiffs [

	^ classDiffs ifNil: [ classDiffs := self calcClassDiffs ]
]

{ #category : #accessing }
SPAddedPackage >> newPackage [
	^ self newObject
]
