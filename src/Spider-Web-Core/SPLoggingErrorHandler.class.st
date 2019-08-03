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

	| dir fname |
	
	dir := FileSystem workingDirectory / 'errors'.
	dir ensureCreateDirectory.
	fname := ((DateAndTime now asString first: 23) replaceAll: $: with: $-), '.log'.
	(dir / fname) writeStreamDo: [ :stream |
		anException signalerContext errorReportOn: stream ]
]
