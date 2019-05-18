Class {
	#name : #SPMethodImageRepository,
	#superclass : #SPMethodRepository,
	#instVars : [
		'methodsByHash'
	],
	#category : #'Spider-Model-Core-Repos'
}

{ #category : #enumerating }
SPMethodImageRepository >> allMethodsDo: aBlock [

	methodsByHash do: aBlock
]

{ #category : #queries }
SPMethodImageRepository >> allSelectors [

	| coll |
	
	coll := Set new.
	self allMethodsDo: [ :each | coll add: each selector; addAll: each messages ].
	^coll
]

{ #category : #queries }
SPMethodImageRepository >> allVariables [

	| coll |
	
	coll := Set new.
	self allMethodsDo: [ :each | coll addAll: each variables ].
	^coll
]

{ #category : #initialization }
SPMethodImageRepository >> initialize [

	super initialize.
	
	methodsByHash := Dictionary new.
]

{ #category : #queries }
SPMethodImageRepository >> selectMethodByHash: aBytes ifAbsent: aBlock [

	^ methodsByHash at: aBytes ifAbsent: aBlock
]

{ #category : #storing }
SPMethodImageRepository >> storeMethod: aMethod [

	^ methodsByHash at: aMethod sourceHash ifAbsentPut: [ aMethod ]
]
