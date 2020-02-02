Class {
	#name : #SPGitRestfulHandler,
	#superclass : #SPRestfulHandler,
	#category : #'Spider-Web-API'
}

{ #category : #'tools registry' }
SPGitRestfulHandler class >> register [
	| handler |
	handler := WAAdmin register: self at: 'git'.
	handler exceptionHandler: SPLoggingErrorHandler.
	handler 
		addFilter: SPContextFilter new;
		addFilter: SPCorsFilter new

]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> findCommit: id [

	| commit |
	
	(self isValidId: id)
		ifTrue: [ commit := self gitRepo getCommitById: id asNumber ifAbsent: [ nil ] ].
	commit isNil
		ifTrue: [ commit := self gitRepo getCommitByShaString: id ifAbsent: [ self notFound ] ].
	^ commit
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> findCommit: id in: repo [

	^ self findCommit: id
]

{ #category : #'get-requests' }
SPGitRestfulHandler >> getCommit: aCommitId [
	<get>
	<path: '/html/commit/{aCommitId}'>
	<produces: 'text/html'>
	
	| commit |
	
	commit := self gitRepo getCommitByShaString: aCommitId ifAbsent: [ ^ self notFound ].
	
	^ self renderHtml: (SPGitCommitDetailsView new
		gitCommit: commit;
		yourself)
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getCommitAsJson: aCommitId [
	<get>
	<path: '/commit/{aCommitId}'>
	<produces: 'application/json'>
	
	| commit repos repo repoRefs |
	
	commit := self findCommit: aCommitId.
	repos := self gitRepo getReposWithCommitSha: commit shaString.
	repos size = 1
		ifTrue: [ 
			repo := repos first.
			repoRefs := self gitRepo getRepoRefsFrom: repo id toCommit: commit id ]
		ifFalse: [ 
			repo := nil.
			repoRefs := #() ].
	
	^ self renderJsonWith: [ :json |
			SPGitCommitJson new
				repoRefs: repoRefs;
				renderCommit: commit from: repo on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getDiffAsJson: aCommitId [
	<get>
	<path: '/diff/{aCommitId}'>
	<produces: 'application/json'>
	
	| aCommit |
	
	aCommit := self findCommit: aCommitId.

	^ self renderJsonWith: [ :json |
					SPDiffJson new
						renderCommitDiff: aCommit on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getDiffAsJson: newCommitId and: oldCommitId [
	<get>
	<path: '/diff/{newCommitId}/{oldCommitId}'>
	<produces: 'application/json'>
	
	| newCommit oldCommit |
	
	newCommit := self findCommit: newCommitId.
	oldCommit := self findCommit: oldCommitId.
				
	^ self renderJsonWith: [ :json |
					SPGitCommitJson new
						renderCommit: newCommit on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getDiffAsJson: aDomain owner: anOwner name: aName id: aCommitId [
	<get>
	<path: '/diff/{aDomain}/{anOwner}/{aName}/commit/{aCommitId}'>
	<produces: 'application/json'>
	
	| repo aCommit |
	
	repo := self gitRepo getRepo: aDomain owner: anOwner name: aName ifAbsent: [ ^ self notFound ].
	aCommit := self findCommit: aCommitId in: repo.
	
	^ self renderJsonWith: [ :json |
			SPDiffJson new
				renderCommit: aCommit on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepo: aDomain owner: anOwner name: aName [
	<get>
	<path: '/html/repos/{aDomain}/{anOwner}/{aName}'>
	<produces: 'text/html'>
	
	| repo |
	
	repo := self gitRepo getRepo: aDomain owner: anOwner name: aName ifAbsent: [ ^ self notFound ].
	
	^ self renderHtml: (SPGitRepoDetailsView new
		gitRepo: repo;
		yourself)
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoAsJson: aDomain owner: anOwner name: aName [
	<get>
	<path: '/repos/{aDomain}/{anOwner}/{aName}'>
	<produces: 'application/json'>
	
	| repo |

	repo := self gitRepo getRepo: aDomain owner: anOwner name: aName ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
					SPGitRepoJson new
						renderRepo: repo on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoBranchAsJson: aDomain owner: anOwner name: aName branch: aBranch [
	<get>
	<path: '/repos/{aDomain}/{anOwner}/{aName}/branch/{aBranch}'>
	<produces: 'application/json'>
	
	| repo branchRef |
	
	repo := self gitRepo getRepo: aDomain owner: anOwner name: aName ifAbsent: [ ^ self notFound ].
	branchRef := repo branchNamed: aBranch ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
					SPGitCommitJson new
						renderBranchRef: branchRef from: repo on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoCommitAsJson: aDomain owner: anOwner name: aName id: aCommitId [
	<get>
	<path: '/repos/{aDomain}/{anOwner}/{aName}/commit/{aCommitId}'>
	<produces: 'application/json'>
	
	| repo commit repoRefs |
	
	repo := self gitRepo getRepo: aDomain owner: anOwner name: aName ifAbsent: [ ^ self notFound ].
	commit := self findCommit: aCommitId in: repo. 
	repoRefs := self gitRepo getRepoRefsFrom: repo id toCommit: commit id.
	
	^ self renderJsonWith: [ :json |
			SPGitCommitJson new
				repo: repo;
				repoRefs: repoRefs;
				renderCommit: commit on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoCommitsAsJson: aDomain owner: anOwner name: aName branch: aBranch [
	<get>
	<path: '/repos/{aDomain}/{anOwner}/{aName}/commits/{aBranch}'>
	<produces: 'application/json'>
	
	| repo branchRef |
	
	repo := self gitRepo getRepo: aDomain owner: anOwner name: aName ifAbsent: [ ^ self notFound ].
	branchRef := repo branchNamed: aBranch ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
					SPGitCommitJson new
						renderCommitList: (branchRef historyList: 100) on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoList [
	<get>
	<path: '/html/repos'>
	<produces: 'text/html'>
	
	| repos |
	
	repos := self gitRepo selectReposByUrl.
	
	^ self renderHtml: (SPGitReposListView new
		list: repos;
		yourself)
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoList: aDomain [
	<get>
	<path: '/repos/{aDomain}'>
	<produces: 'application/json'>
	
	| offset limit repos hasMore |
	
	offset := self offsetParameter.
	limit := self limitParameter.
	
	repos := self gitRepo selectReposByUrlWithDomain: aDomain offset: offset limit: limit.
	hasMore := repos size > limit.
	hasMore ifTrue: [ 
		repos := repos allButLast ].
	
	^ self renderJsonWith: [ :json |
					SPGitRepoJson new
						renderList: repos more: hasMore on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoList: aDomain owner: anOwner [
	<get>
	<path: '/repos/{aDomain}/{anOwner}'>
	<produces: 'application/json'>
	
	| offset limit repos hasMore |
	
	offset := self offsetParameter.
	limit := self limitParameter.
	
	repos := self gitRepo selectReposByUrlWithDomain: aDomain owner: anOwner offset: offset limit: limit.
	hasMore := repos size > limit.
	hasMore ifTrue: [ 
		repos := repos allButLast ].
	
	^ self renderJsonWith: [ :json |
					SPGitRepoJson new
						renderList: repos more: hasMore on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoListAsJson [
	<get>
	<path: '/repos'>
	<produces: 'application/json'>
	
	| limit criteria repos hasMore |
	
	limit := self limitParameterDefault: 15 max: 50.
	criteria := self requestStringSearchCriteria
		wildcardBefore: true;
		yourself.
	repos := self gitRepo getRepos: criteria max: limit+1.
	hasMore := false.
	repos size > limit
		ifTrue: [ 
			hasMore := true. 
			repos := repos allButLast ].
	
	^ self renderJsonWith: [ :json |
			SPGitRepoJson new
				renderList: repos more: hasMore on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoTagAsJson: aDomain owner: anOwner name: aName tag: aTag [
	<get>
	<path: '/repos/{aDomain}/{anOwner}/{aName}/tag/{aTag}'>
	<produces: 'application/json'>
	
	| repo branchRef |
	
	repo := self gitRepo getRepo: aDomain owner: anOwner name: aName ifAbsent: [ ^ self notFound ].
	branchRef := repo tagNamed: aTag ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
					SPGitCommitJson new
						renderTagRef: branchRef from: repo on: json ]
]
