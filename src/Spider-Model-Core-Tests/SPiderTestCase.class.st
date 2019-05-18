Class {
	#name : #SPiderTestCase,
	#superclass : #TestCase,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #accessing }
SPiderTestCase class >> defaultTimeLimit [ 

	^ 60 seconds
]

{ #category : #accessing }
SPiderTestCase >> classRepo [

	^ self context classRepo
]

{ #category : #accessing }
SPiderTestCase >> context [

	^ context ifNil: [ context := self createContext ]
]

{ #category : #accessing }
SPiderTestCase >> createContext [

	^ SPiderImageContext new
]

{ #category : #accessing }
SPiderTestCase >> gitRepo [

	^ self context gitRepo
]

{ #category : #accessing }
SPiderTestCase >> mcPackageRepo [

	^ self context mcPackageRepo
]

{ #category : #accessing }
SPiderTestCase >> methodRepo [

	^ self context methodRepo
]

{ #category : #accessing }
SPiderTestCase >> packageRepo [

	^ self context packageRepo
]

{ #category : #running }
SPiderTestCase >> tearDown [ 

	context notNil
		ifTrue: [ 
			context close.
			context := nil ].
		
	super tearDown
]
