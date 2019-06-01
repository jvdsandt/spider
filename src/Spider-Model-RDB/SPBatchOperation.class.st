Class {
	#name : #SPBatchOperation,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #accessing }
SPBatchOperation >> classRepo [

	^ context classRepo
]

{ #category : #accessing }
SPBatchOperation >> context [
	^ context
]

{ #category : #accessing }
SPBatchOperation >> context: anObject [
	context := anObject
]

{ #category : #accessing }
SPBatchOperation >> glorpSession [

	^ context glorpSession
]

{ #category : #accessing }
SPBatchOperation >> packageRepo [

	^ context packageRepo
]
