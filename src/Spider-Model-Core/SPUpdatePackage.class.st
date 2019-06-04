Class {
	#name : #SPUpdatePackage,
	#superclass : #SPDiffUpdate,
	#instVars : [
		'classDiffs'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #accessing }
SPUpdatePackage >> classDiffs [

	^ classDiffs ifNil: [ classDiffs := self newObject compareClassesWith: self oldObject ]
]
