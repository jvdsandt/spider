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

	^ self context classRepo
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
SPBatchOperation >> gitRepo [

	^ self context gitRepo
]

{ #category : #accessing }
SPBatchOperation >> glorpSession [

	^ self context glorpSession
]

{ #category : #initialization }
SPBatchOperation >> initialize [

	super initialize.
	
	context := SPCurrentContext value
]

{ #category : #accessing }
SPBatchOperation >> p3client [

	^ self context client
]

{ #category : #accessing }
SPBatchOperation >> p3prepare: sqlString [

	^ self queries at: sqlString ifAbsentPut: [ queries createQuery: sqlString ]
]

{ #category : #accessing }
SPBatchOperation >> packageRepo [

	^ self context packageRepo
]

{ #category : #accessing }
SPBatchOperation >> queries [

	^ queries ifNil: [ queries := SPP3Queries new initWithClient: self p3client ]
]
