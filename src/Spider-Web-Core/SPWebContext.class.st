Class {
	#name : #SPWebContext,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#classVars : [
		'DatabaseUrl',
		'Default'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPWebContext class >> databaseUrl [

	^ DatabaseUrl
]

{ #category : #accessing }
SPWebContext class >> databaseUrl: aString [

	DatabaseUrl := aString
]

{ #category : #accessing }
SPWebContext class >> default [

	^ Default ifNil: [ Default := self newDefault ]
]

{ #category : #accessing }
SPWebContext class >> default: aWebContext [

	Default := aWebContext 
]

{ #category : #'class initialization' }
SPWebContext class >> initialize [

	GRPlatform current addToShutDownList: self
]

{ #category : #'instance creation' }
SPWebContext class >> newDefault [

	| context |
	
	context := SPiderPostgreSQLContext openOnUrl: self databaseUrl.

	^ self new
			context: context;
			yourself
]

{ #category : #'system startup' }
SPWebContext class >> shutDown [

	Default isNil
		ifTrue: [ ^ self ]. 

	Default close.
	Default := nil
]

{ #category : #'class initialization' }
SPWebContext class >> unload [
	GRPlatform current
		removeFromStartUpList: self;
		removeFromShutDownList: self
]

{ #category : #actions }
SPWebContext >> close [

	context notNil
		ifTrue: [ 
			[ context close ] ensure: [ context := nil ] ].

]

{ #category : #accessing }
SPWebContext >> context [
	^ context
]

{ #category : #accessing }
SPWebContext >> context: anObject [
	context := anObject
]

{ #category : #enumerating }
SPWebContext >> do: aBlock [

	^ SPCurrentContext 
		value: self context
		during: aBlock
]

{ #category : #accessing }
SPWebContext >> glorpSession [
	^ context glorpSession
]

{ #category : #accessing }
SPWebContext >> queries [

	^ SPQueries new
			glorpSession: self glorpSession;
			context: context;
			yourself
]
