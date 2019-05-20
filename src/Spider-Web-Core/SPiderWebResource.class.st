Class {
	#name : #SPiderWebResource,
	#superclass : #Object,
	#instVars : [
		'webContext',
		'request'
	],
	#category : #'Spider-Web-Core-API'
}

{ #category : #testing }
SPiderWebResource class >> canHandle: aRequest [

	^ aRequest method = #GET
]

{ #category : #accessing }
SPiderWebResource class >> path [

	self subclassResponsibility 
]

{ #category : #accessing }
SPiderWebResource >> defaultLimit [

	^ 100
]

{ #category : #execution }
SPiderWebResource >> execute [

	^ ZnResponse ok: (ZnEntity json: '{}')
]

{ #category : #'as yet unclassified' }
SPiderWebResource >> paramAfterKey [

	^ self request uri queryAt: 'afterKey' ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
SPiderWebResource >> paramLimit [

	| value |
	
	value := self request uri queryAt: 'limit' ifAbsent: [ ^ self defaultLimit ].
	value := value asInteger.
	^ value 
			ifNil: [ self defaultLimit ]
			ifNotNil: [ value ]
]

{ #category : #execution }
SPiderWebResource >> queries [

	^ self webContext queries
]

{ #category : #rendering }
SPiderWebResource >> render: aBlock [

	^ String streamContents: [ :stream |
		| context document canvas |
		document := WAJsonDocument on: stream.
		context := WARenderContext new
			actionUrl: WAUrl new;
			document: document;
			yourself.
		 canvas := WAJsonCanvas context: context.
		canvas render: aBlock.
		document close ]
]

{ #category : #accessing }
SPiderWebResource >> request [
	^ request
]

{ #category : #accessing }
SPiderWebResource >> request: anObject [
	request := anObject
]

{ #category : #accessing }
SPiderWebResource >> webContext [
	^ webContext
]

{ #category : #accessing }
SPiderWebResource >> webContext: anObject [
	webContext := anObject
]
