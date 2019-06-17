Class {
	#name : #SPRestfulHandler,
	#superclass : #WARestfulHandler,
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPRestfulHandler >> context [

	^ self webContext context
]

{ #category : #accessing }
SPRestfulHandler >> gitRepo [

	^ self context gitRepo
]

{ #category : #accessing }
SPRestfulHandler >> notFound [

	^ self requestContext respond: [ :response |
      	response notFound ]

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

{ #category : #accessing }
SPRestfulHandler >> webContext [

	^ SPWebContext default
]
