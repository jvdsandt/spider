Class {
	#name : #SPP3Query,
	#superclass : #Object,
	#instVars : [
		'statement',
		'inputMapper',
		'outputMapper'
	],
	#category : #'Spider-Model-RDB'
}

{ #category : #'instance creation' }
SPP3Query class >> statement: aStatement [

	^ self new initWithStatement: aStatement
]

{ #category : #'instance creation' }
SPP3Query class >> statement: aStatement input: inputMapper [

	^ (self statement: aStatement)
			inputMapper: inputMapper;
			yourself
]

{ #category : #'instance creation' }
SPP3Query class >> statement: aStatement input: inputMapper output: outputMapper [

	^ (self statement: aStatement)
			inputMapper: inputMapper;
			outputMapper: outputMapper;
			yourself
]

{ #category : #'initialize-release' }
SPP3Query >> close [

	statement notNil
		ifTrue: [ 
			statement close.
			statement := nil ]
]

{ #category : #actions }
SPP3Query >> execute: input [

	| inputRow |
	
	inputRow := self mapInput: input.
	^ statement execute: inputRow.
]

{ #category : #actions }
SPP3Query >> executeBatch: inputs [

	| inputRows |
	
	inputs isEmpty
		ifTrue: [ ^ #() ].
	
	inputRows := inputs collect: [ :each | self mapInput: each ].
	^ statement executeBatch: inputRows.
]

{ #category : #actions }
SPP3Query >> getOne: input [

	^ self getOne: input ifNone: [ nil ]
]

{ #category : #actions }
SPP3Query >> getOne: input ifNone: aBlock [

	| inputRow result |
	
	inputRow := self mapInput: input.
	result := statement query: inputRow.

	^ result data isEmptyOrNil 
		ifTrue: [ aBlock value ]
		ifFalse: [ self mapOutput: result firstRecord ]
]

{ #category : #actions }
SPP3Query >> getOneBatch: inputs [

	| inputRows results |
	
	inputs isEmpty
		ifTrue: [ ^ #() ].

	inputRows := inputs collect: [ :each | self mapInput: each ].
	results := statement queryAll: inputRows.

	^ results collect: [ :each |
			each data isEmptyOrNil 
				ifTrue: [ nil ]
				ifFalse: [ self mapOutput: each firstRecord ] ]
]

{ #category : #'initialize-release' }
SPP3Query >> initWithStatement: aStatement [

	statement := aStatement
]

{ #category : #accessing }
SPP3Query >> inputMapper [
	^ inputMapper
]

{ #category : #accessing }
SPP3Query >> inputMapper: anObject [
	inputMapper := anObject
]

{ #category : #mapping }
SPP3Query >> mapInput: input [
	" Convert input tow a row/array that can be used as input for the query"

	inputMapper notNil
		ifTrue: [ ^ inputMapper value: input ].
		
	^ (input isCollection and: [ input isString not and: [ input size = statement paramDescriptions size ] ])
			ifTrue: [ input ]
			ifFalse: [ Array with: input ]
]

{ #category : #mapping }
SPP3Query >> mapOutput: row [

	outputMapper isNil
		ifTrue: [
			^ row size = 1
				ifTrue: [ row at: 1 ]
				ifFalse: [ row ] ].
		
	(outputMapper isClosure and: [ outputMapper argumentCount = row size ])
		ifTrue: [ ^ outputMapper valueWithArguments: row ].
			
	^ outputMapper value: row
]

{ #category : #accessing }
SPP3Query >> outputMapper [
	^ outputMapper
]

{ #category : #accessing }
SPP3Query >> outputMapper: anObject [
	outputMapper := anObject
]

{ #category : #actions }
SPP3Query >> query: input [

	| inputRow result |
	
	inputRow := self mapInput: input.
	result := statement query: inputRow.

	^ self shouldMapOutput 
			ifTrue: [ result data collect: [ :row | self mapOutput: row ] ]
			ifFalse: [ result data ]
]

{ #category : #actions }
SPP3Query >> queryAll: inputs [

	| inputRows results |
	
	inputRows := inputs collect: [ :each | self mapInput: each ].
	results := statement queryAll: inputRows.
	
	^ self shouldMapOutput
		ifTrue: [ 
			results collect: [ :each |
				each data collect: [ :row | self mapOutput: row ] ] ]
		ifFalse: [ 
			results collect: [ :each | each data ] ]
]

{ #category : #testing }
SPP3Query >> shouldMapOutput [

	^ outputMapper notNil or: [ statement fieldCount = 1 ]
]

{ #category : #accessing }
SPP3Query >> statement [
	^ statement
]
