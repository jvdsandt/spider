Class {
	#name : #SPLoggingErrorHandler,
	#superclass : #WAErrorHandler,
	#category : #'Spider-Web-Core'
}

{ #category : #actions }
SPLoggingErrorHandler >> handleDefault: anException [

	self logException: anException.
	
	self requestContext respond: [ :response |
		response
			internalError;
			contentType: (WAMimeType textHtml
				charset: self requestContext charSet;
				yourself);
			nextPutAll: (WAHtmlCanvas builder
				fullDocument: true;
				render: [ :html | html error: 'kapot!' ]) ]
]

{ #category : #'as yet unclassified' }
SPLoggingErrorHandler >> logException: anException [
]
