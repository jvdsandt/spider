Class {
	#name : #SPGitRestfulHandler,
	#superclass : #SPRestfulHandler,
	#category : #'Spider-Web-Core'
}

{ #category : #'tools registry' }
SPGitRestfulHandler class >> register [

	| handler |

	handler := WAAdmin register: self at: 'git'.
	
	handler configuration addParent: WAExceptionFilterConfiguration instance.
	handler preferenceAt: #exceptionHandler put: SPLoggingErrorHandler.
	handler addFilter: WAExceptionFilter new.
]

{ #category : #'get-requests' }
SPGitRestfulHandler >> getCommit: aCommitId [
	<get>
	<path: '/commit/{aCommitId}'>
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
	
	| commit |
	
	(self isValidId: aCommitId)
		ifTrue: [ commit := self gitRepo getCommitById: aCommitId asNumber ifAbsent: [ nil ] ].
	commit isNil
		ifTrue: [ commit := self gitRepo getCommitByShaString: aCommitId ifAbsent: [ ^ self notFound ] ].
	
	^ self renderJsonWith: [ :json |
					SPGitCommitJson new
						renderCommit: commit on: json ]
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getCommitList [
	<get>
	<path: '/commits'>
	

]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepo: aDomain owner: anOwner name: aName [
	<get>
	<path: '/repos/{aDomain}/{anOwner}/{aName}'>
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
SPGitRestfulHandler >> getRepoCommitAsJson: aDomain owner: anOwner name: aName id: aCommitId [
	<get>
	<path: '/repos/{aDomain}/{anOwner}/{aName}/commit/{aCommitId}'>
	<produces: 'application/json'>
	
	| repo commit |
	
	repo := self gitRepo getRepo: aDomain owner: anOwner name: aName ifAbsent: [ ^ self notFound ].
	commit := self gitRepo getCommitByShaString: aCommitId ifAbsent: [ ^ self notFound ].
	
	^ self renderJsonWith: [ :json |
					SPGitCommitJson new
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
	<path: '/repos'>
	<produces: 'text/html'>
	
	| repos |
	
	repos := self gitRepo selectReposByUrl.
	
	^ self renderHtml: (SPGitReposListView new
		list: repos;
		yourself)
]

{ #category : #'as yet unclassified' }
SPGitRestfulHandler >> getRepoListAsJson [
	<get>
	<path: '/repos'>
	<produces: 'application/json'>
	
	| repos |
	
	repos := self gitRepo selectReposByUrl.
	
	^ self renderJsonWith: [ :json |
					SPGitRepoJson new
						renderList: repos on: json ]
]
