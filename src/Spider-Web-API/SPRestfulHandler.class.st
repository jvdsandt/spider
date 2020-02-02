Class {
	#name : #SPRestfulHandler,
	#superclass : #WARestfulHandler,
	#category : #'Spider-Web-API'
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
SPRestfulHandler >> diffRepo [

	^ self context diffRepo
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

{ #category : #'accessing parameters' }
SPRestfulHandler >> limitParameter [

	^ self limitParameterDefault: self defaultLimit max: self maxLimit
]

{ #category : #'accessing parameters' }
SPRestfulHandler >> limitParameterDefault: aDefault max: aMax [

	| value |
	
	value := self requestIntParameterAt: 'limit' ifAbsent: [ ^ aDefault ].
	^ (value max: 1) min: aMax
]

{ #category : #accessing }
SPRestfulHandler >> maxLimit [

	^ 250
]

{ #category : #accessing }
SPRestfulHandler >> mcPackageRepo [

	^ self context mcPackageRepo
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

{ #category : #'accessing parameters' }
SPRestfulHandler >> offsetParameter [

	^ self requestIntParameterAt: 'offset' ifAbsent: [ nil ]
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

{ #category : #'accessing parameters' }
SPRestfulHandler >> requestBoolParameterAt: aName ifAbsent: aBlock [

	| value |
	
	value := 	self requestParameterAt: aName ifAbsent: [ ^ aBlock value ].
	^ value = 'true' or: [ value = '1' ]
]

{ #category : #'accessing parameters' }
SPRestfulHandler >> requestIntParameterAt: aName ifAbsent: aBlock [

	^ (self requestContext request at: aName ifAbsent: [ ^ aBlock value ]) asUnsignedInteger
]

{ #category : #'accessing parameters' }
SPRestfulHandler >> requestParameterAt: aName ifAbsent: aBlock [

	^ self requestContext request at: aName ifAbsent: aBlock
]

{ #category : #'accessing parameters' }
SPRestfulHandler >> requestStringSearchCriteria [
	"Answer a SPStringSearchCriteria instance initialized using request parameters."

	^ SPStringSearchCriteria new
		term: (self requestParameterAt: 'q' ifAbsent: [ '' ]);
		caseSensitive: (self requestBoolParameterAt: 'caseSensitive' ifAbsent: [ false ]);
		wildcardBefore: (self requestBoolParameterAt: 'wcb' ifAbsent: [ false ]);
		wildcardAfter: (self requestBoolParameterAt: 'wca' ifAbsent: [ true ]);
		after: (self requestParameterAt: 'after' ifAbsent: [ nil ]);
		yourself
]

{ #category : #accessing }
SPRestfulHandler >> webContext [

	^ SPWebContext default
]
