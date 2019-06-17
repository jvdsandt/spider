Class {
	#name : #SPGitRestfulHandler,
	#superclass : #SPRestfulHandler,
	#category : #'Spider-Web-Core'
}

{ #category : #'tools registry' }
SPGitRestfulHandler class >> register [
	WAAdmin register: self at: 'git'
]

{ #category : #'as yet unclassified' }
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
