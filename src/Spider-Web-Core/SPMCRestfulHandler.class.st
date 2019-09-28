Class {
	#name : #SPMCRestfulHandler,
	#superclass : #SPRestfulHandler,
	#category : #'Spider-Web-Core-API'
}

{ #category : #'tools registry' }
SPMCRestfulHandler class >> register [
	| handler |
	handler := WAAdmin register: self at: 'mc'.
	handler exceptionHandler: SPLoggingErrorHandler.
	handler 
		addFilter: SPContextFilter new;
		addFilter: SPCorsFilter new
]

{ #category : #'as yet unclassified' }
SPMCRestfulHandler >> getAuthorList [
	<get>
	<path: '/authors'>
	<produces: 'application/json'>
	
	| offset limit authors hasMore |
	
	offset := self offsetParameter.
	limit := self limitParameter.
	
	authors := self mcPackageRepo selectAuthorsLike: '%' offset: offset limit: limit + 1.
	hasMore := authors size > limit.
	hasMore ifTrue: [ 
		authors := authors allButLast ].
	
	^ self renderJsonWith: [ :json |
			SPMonticelloAuthorJson new
				renderList: authors more: hasMore on: json ]
]

{ #category : #'as yet unclassified' }
SPMCRestfulHandler >> getPackageDetails: anId [
	<get>
	<path: '/packages/{anId}'>
	<produces: 'application/json'>
	
	| mcPackage |
	
	(self isValidId: anId)
		ifTrue: [ 
			mcPackage := self mcPackageRepo getMCPackageById: anId ifAbsent: [ ^ self notFound ] ]
		ifFalse: [ 
			| uuid |
			uuid := [ ByteArray newFrom: (UUID fromString: anId) ] on: Error do: [ ^ self notFound ].
			mcPackage := self mcPackageRepo getMCPackageByMcId: uuid ifAbsent: [ ^ self notFound ] ].

	^ self renderJsonWith: [ :json |
			SPMonticelloPackageJson new
				renderPackageItem: mcPackage on: json ]
]

{ #category : #'as yet unclassified' }
SPMCRestfulHandler >> getRepoDetails: anId [
	<get>
	<path: '/repos/{anId}'>
	<produces: 'application/json'>
	
	| repo |

	repo := self mcPackageRepo getMCRepoById: anId ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
			SPMonticelloRepoJson new
				renderDetails: repo on: json ]
]

{ #category : #'as yet unclassified' }
SPMCRestfulHandler >> getRepoList [
	<get>
	<path: '/repos'>
	<produces: 'application/json'>
	
	| offset limit repos hasMore |
	
	offset := self offsetParameter.
	limit := self limitParameter.
	
	repos := self mcPackageRepo selectReposByUrl: offset limit: limit + 1.
	hasMore := repos size > limit.
	hasMore ifTrue: [ 
		repos := repos allButLast ].
	
	^ self renderJsonWith: [ :json |
			SPMonticelloRepoJson new
				renderList: repos more: hasMore on: json ]
]

{ #category : #'as yet unclassified' }
SPMCRestfulHandler >> getRepoPackageList: repoId [
	<get>
	<path: '/repos/{repoId}/packages'>
	<produces: 'application/json'>
	
	| repo offset limit mcPackages hasMore |
	
	repo := self mcPackageRepo getMCRepoById: repoId ifAbsent: [ ^ self notFound ].

	offset := self offsetParameter.
	limit := self limitParameter.
	
	mcPackages := self mcPackageRepo selectRepoPacakges: repo offset: offset limit: limit + 1.
	hasMore := mcPackages size > limit.
	hasMore ifTrue: [ 
		mcPackages := mcPackages allButLast ].
	
	^ self renderJsonWith: [ :json |
			SPMonticelloPackageJson new
				renderRepoPackageList: mcPackages more: hasMore on: json ]
]
