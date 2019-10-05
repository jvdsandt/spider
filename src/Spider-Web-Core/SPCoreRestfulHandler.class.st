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
	
	| spiderClass packageId category |
	
	spiderClass := self classRepo getClassById: anId ifAbsent: [ ^ self notFound ].
	packageId := self requestContext request at: 'packageId' ifAbsent: [ nil ].
	category := packageId isNil
		ifTrue: [ nil ]
		ifFalse: [ self packageRepo getClassCategoryFor: spiderClass id in: packageId ].
	
	^ self renderJsonWith: [ :json |
				SPClassJson new renderClass: spiderClass in: category on: json ]
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
SPCoreRestfulHandler >> getNames: aTerm [
	<get>
	<path: '/search_names/{aTerm}'>
	<produces: 'application/json'>
	
	| limit term result |
	
	limit := self limitParameterDefault: 10 max: 50.
	term := aTerm select: [ :ch | ch isLetter or: [ ch isDigit ] ].
	result := OrderedDictionary new.
	
	term size >= 3
		ifTrue: [ 
			term := '%', term, '%'.
			result
				at: 'selecors' put: (self methodRepo getSelectorsLike: term max: limit);
				at: 'classNames' put: (self classRepo getClassNamesLike: term max: limit);
				at: 'packageNames' put: (self packageRepo getPackageNamesLike: term max: limit) ].
		
	^ self renderJsonWith: result
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
