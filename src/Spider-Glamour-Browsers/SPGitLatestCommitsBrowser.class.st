Class {
	#name : #SPGitLatestCommitsBrowser,
	#superclass : #SPGlamourGitBrowser,
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #'instance creation' }
SPGitLatestCommitsBrowser >> createBrowser [

	^ GLMCompositePresentation new tabulator 
			with: [ :t |
				t title: 'Spider Latest Git Commits'.
				t 
					column: #commits.
				t transmit to: #commits; andShow: [ :composite | 
					self createCommitsTable: composite ] ]
]

{ #category : #'instance creation' }
SPGitLatestCommitsBrowser >> open [

	| list |
	
	list := self context gitRepo getLatestCommits: 500.
	self createBrowser openOn: list
]
