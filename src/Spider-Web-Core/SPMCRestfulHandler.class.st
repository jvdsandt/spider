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
