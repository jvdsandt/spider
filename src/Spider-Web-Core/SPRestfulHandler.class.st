Class {
	#name : #SPRestfulHandler,
	#superclass : #WARestfulHandler,
	#category : #'Spider-Web-Core-API'
}

{ #category : #accessing }
SPRestfulHandler >> classRepo [

	^ self context classRepo
]

{ #category : #accessing }
SPRestfulHandler >> context [

	^ self webContext context
]

{ #category : #private }
SPRestfulHandler >> createRoutes [
	"Creates a collection of routes for the receiver. Override this method in subclasses to explicitely create the routes instead of using the default implementation that builds the routes using annotated methods (pragmas)."

	^ SPRouteBuilder createRoutesFrom: self class to: SPRestfulHandler
]

{ #category : #accessing }
SPRestfulHandler >> defaultLimit [

	^ 100
]

{ #category : #accessing }
SPRestfulHandler >> gitRepo [

	^ self context gitRepo
]

{ #category : #testing }
SPRestfulHandler >> isJsonRequest [

	| acceptHeader |
	
	acceptHeader := self requestContext request headerAt: 'accept' ifAbsent: [ ^ false ].
	^ acceptHeader notNil and: [ (acceptHeader indexOfSubCollection: 'application/json') > 0 ]
]

{ #category : #testing }
SPRestfulHandler >> isValidId: aString [

	^ aString notNil and: [ 
			aString size < 19 and: [ 
				aString allSatisfy: [ :ch | ch isDigit ] ] ]
]

{ #category : #accessing }
SPRestfulHandler >> limitParameter [

	| value |
	
	value := self requestContext request at: 'limit' ifAbsent: [ ^ self defaultLimit ].
	^ (value asInteger max: 1) min: self maxLimit
]

{ #category : #accessing }
SPRestfulHandler >> maxLimit [

	^ 250
]

{ #category : #accessing }
SPRestfulHandler >> methodRepo [

	^ self context methodRepo
]

{ #category : #accessing }
SPRestfulHandler >> notFound [

	self isJsonRequest 
		ifTrue: [ ^ self notFoundJson ].

	^ self requestContext respond: [ :response |
      	response notFound ]

]

{ #category : #accessing }
SPRestfulHandler >> notFoundJson [

	^ self requestContext respond: [ :response |
      	response 
			notFound;
			contentType: WAMimeType applicationJson;
			nextPutAll: (self renderJsonWith: [ :json |
				json object: [ 
					json key: 'error' value: 'notFound' ] ]) ]
]

{ #category : #accessing }
SPRestfulHandler >> offsetParameter [

	| offset |
	
	offset := self requestContext request at: 'offset' ifAbsent: [ ^ nil ].
	^ offset asInteger max: 0
]

{ #category : #accessing }
SPRestfulHandler >> packageRepo [

	^ self context packageRepo
]

{ #category : #rendering }
SPRestfulHandler >> renderHtml: aComponent [

	| pageComponent |
	
	pageComponent := SPDefaultRESTPage new
		contentPanel: aComponent;
		yourself.

	^ WAHtmlCanvas builder
		fullDocument: true;
		rootBlock: [ :root | pageComponent updateRoot: root ];
		render: [ :html | html render: pageComponent ]
]

{ #category : #rendering }
SPRestfulHandler >> renderJsonWith: anObject [

	^ WAJsonCanvas builder render: anObject
]

{ #category : #accessing }
SPRestfulHandler >> webContext [

	^ SPWebContext default
]
