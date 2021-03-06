Class {
	#name : #SPCoreRestfulHandler,
	#superclass : #SPRestfulHandler,
	#category : #'Spider-Web-API'
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
	packageId := self requestIntParameterAt: 'packageId' ifAbsent: [ nil ].
	category := packageId isNil
		ifTrue: [ nil ]
		ifFalse: [ self packageRepo getClassCategoryFor: spiderClass id in: packageId ].
	
	^ self renderJsonWith: [ :json |
			SPClassJson new 
				spiderClass: spiderClass;
				category: category;
				gitRootId: (self requestIntParameterAt: 'gitRootId' ifAbsent: [ nil ]);
				renderClassOn: json ]
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getClassNameAsJson: aName [
	<get>
	<path: '/class_names/{aName}'>
	<produces: 'application/json'>
	
	| gitRootId info |
	
	gitRootId := self requestIntParameterAt: 'gitRootId' ifAbsent: [ nil ].

	info := (SPClassNameInfo new initWithName: aName gitRootId: gitRootId)
		retrieveInfo: self context;
		yourself.
	info versionCount = 0
		ifTrue: [ ^ self notFoundJson ].

	^ self renderJsonWith: [ :json |
			SPPackageNameJson new 
				info: info;
				renderContentOn: json ]
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getMethodAsJson: anId [
	<get>
	<path: '/methods/{anId}'>
	<produces: 'application/json'>
	
	| method gitRootId className isMeta |
	
	method := self methodRepo getMethodById: anId ifAbsent: [ ^ self notFound ].
	gitRootId := self requestIntParameterAt: 'gitRootId' ifAbsent: [ nil ].
	className := self requestParameterAt: 'className' ifAbsent: [ nil ].
	isMeta := self requestBoolParameterAt: 'isMeta' ifAbsent: [ nil ].
	
	^ self renderJsonWith: [ :json |
			SPMethodJson new 
				method: method;
				gitRootId: gitRootId className: className meta: isMeta;
				renderMethodOn: json ]
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
			SPPackageJson new 
				package: package;
				gitRootId: (self requestIntParameterAt: 'gitRootId' ifAbsent: [ nil ]);
				renderPackageOn: json ]
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getPackageNameAsJson: aName [
	<get>
	<path: '/package_names/{aName}'>
	<produces: 'application/json'>
	
	| gitRootId info |
	
	gitRootId := self requestIntParameterAt: 'gitRootId' ifAbsent: [ nil ].

	info := (SPPackageNameInfo new initWithName: aName gitRootId: gitRootId)
		retrieveInfo: self context;
		yourself.
	info versionCount = 0
		ifTrue: [ ^ self notFoundJson ].

	^ self renderJsonWith: [ :json |
			SPPackageNameJson new 
				info: info;
				renderContentOn: json ]
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getPackageVersionsAsJson: aName [
	<get>
	<path: '/package_versions/{aName}'>
	<produces: 'application/json'>
	
	| gitRootId list |
	
	gitRootId := self requestIntParameterAt: 'gitRootId' ifAbsent: [ nil ].
	
	list := self diffRepo gitVersionsOfPackageNamed: aName in: gitRootId. 	

	^ self renderJsonWith: [ :json |
			SPGitPackageVersionListJson new 
				name: aName;
				list: list;
				renderContentOn: json ]
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getSearch [
	<get>
	<path: '/search'>
	<produces: 'application/json'>
	
	| limit criteria result |
	
	limit := self limitParameterDefault: 10 max: 50.
	criteria := self requestStringSearchCriteria.
	
	result := Dictionary new.
	criteria hasValidTerm
		ifTrue: [ 
			result
				at: 'selectors' put: (self methodRepo getSelectors: criteria max: limit);
				at: 'classNames' put: (self classRepo getClassNames: criteria max: limit);
				at: 'packageNames' put: (self packageRepo getPackageNames: criteria max: limit) ].
		
	^ self renderJsonWith: result
]

{ #category : #'as yet unclassified' }
SPCoreRestfulHandler >> getSelectorAsJson: aName [
	<get>
	<path: '/selectors/{aName}'>
	<produces: 'application/json'>
	
	| gitRootId info |
	
	gitRootId := self requestIntParameterAt: 'gitRootId' ifAbsent: [ nil ].

	info := (SPSelectorInfo new initWithName: aName gitRootId: gitRootId)
		retrieveInfo: self context;
		yourself.
	info versionCount = 0
		ifTrue: [ ^ self notFoundJson ].

	^ self renderJsonWith: [ :json |
			SPSelectorJson new 
				info: info;
				renderContentOn: json ]
]
