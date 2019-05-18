Class {
	#name : #SPGlorpNode,
	#superclass : #SPGlorp,
	#instVars : [
		'id',
		'transaction'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #comparing }
SPGlorpNode >> = otherNode [

	self == otherNode 
		ifTrue: [ ^ true ].
	self class = otherNode class
		ifFalse: [ ^ false ].
	^ self id = otherNode id
]

{ #category : #comparing }
SPGlorpNode >> hash [

	^ self id hash
]

{ #category : #accessing }
SPGlorpNode >> id [
	^ id
]
