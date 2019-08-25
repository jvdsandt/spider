Class {
	#name : #SPCoreRestfulHandler,
	#superclass : #SPRestfulHandler,
	#category : #'Spider-Web-Core-API'
}

{ #category : #'tools registry' }
SPCoreRestfulHandler class >> register [
	| handler |
	handler := WAAdmin register: self at: 'core'.
	handler exceptionHandler: SPLoggingErrorHandler.
	handler 
		addFilter: SPContextFilter new;
		addFilter: SPCorsFilter new

]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getClassAsJson: anId [
	<get>
	<path: '/classes/{anId}'>
	<produces: 'application/json'>
	
	| spiderClass |
	
	spiderClass := self classRepo getClassById: anId ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
				SPClassJson new renderClass: spiderClass on: json ]
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getMethodAsJson: anId [
	<get>
	<path: '/methods/{anId}'>
	<produces: 'application/json'>
	
	| method |
	
	method := self methodRepo getMethodById: anId ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
				SPMethodJson new renderMethod: method on: json ]
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getNamesList [
	<get>
	<path: '/_names'>
	<produces: 'text/html'>
	
	| packages |
	
	packages := self packageRepo getAllPackageNames.
	
	^ self renderHtml: (SPPackageNamesListView new
		list: packages;
		yourself)
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getPackageAsJson: anId [
	<get>
	<path: '/packages/{anId}'>
	<produces: 'application/json'>
	
	| package |
	
	package := self packageRepo getPackageById: anId ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
				SPPackageJson new renderPackage: package on: json ]
]
