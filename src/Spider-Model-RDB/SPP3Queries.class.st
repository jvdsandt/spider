Class {
	#name : #SPP3Queries,
	#superclass : #Object,
	#instVars : [
		'client',
		'queries'
	],
	#category : #'Spider-Model-RDB'
}

{ #category : #enumerating }
SPP3Queries >> at: aKey ifAbsentPut: aBlock [

	^ queries at: aKey ifAbsentPut: aBlock
]

{ #category : #'initialize-release' }
SPP3Queries >> close [

	queries do: [ :each | each close ].
	queries removeAll.


]

{ #category : #enumerating }
SPP3Queries >> createQuery: sql [

	^ self createQuery: sql input: nil
]

{ #category : #enumerating }
SPP3Queries >> createQuery: sql input: inputMapper [

	| statement |
	
	statement := client prepare: sql.
	^ SPP3Query statement: statement input: inputMapper
]

{ #category : #enumerating }
SPP3Queries >> createSelect: sql [

	^ self createSelect: sql input: nil output: nil
]

{ #category : #enumerating }
SPP3Queries >> createSelect: sql input: inputMapper [

	^ self createSelect: sql input: inputMapper output: nil
]

{ #category : #enumerating }
SPP3Queries >> createSelect: sql input: inputMapper output: outputMapper [

	| statement |
	
	statement := client prepare: sql.
	
	^ SPP3Query statement: statement
			input: inputMapper 
			output: outputMapper

]

{ #category : #enumerating }
SPP3Queries >> createSelect: sql output: outputMapper [

	^ self createSelect: sql input: nil output: outputMapper
]

{ #category : #'initialize-release' }
SPP3Queries >> initWithClient: aP3Client [

	client := aP3Client.
	queries := Dictionary new.

]
