Class {
	#name : #SPBatchOperation,
	#superclass : #Object,
	#instVars : [
		'context',
		'queries'
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
SPBatchOperation >> p3client [

	^ context client
]

{ #category : #accessing }
SPBatchOperation >> p3prepare: sqlString [

	^ self queries at: sqlString ifAbsentPut: [ queries createQuery: sqlString ]
]

{ #category : #accessing }
SPBatchOperation >> packageRepo [

	^ context packageRepo
]

{ #category : #accessing }
SPBatchOperation >> queries [

	^ queries ifNil: [ queries := SPP3Queries new initWithClient: self p3client ]
]
