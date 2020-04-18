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
					row: #commits;
					row: #description.
				t transmit to: #commits; andShow: [ :composite | 
					self createCommitsTable: composite ].
				t transmit from: #commits; to: #description; andShow: [ :composite |
					composite text
						title: 'Commit Info';
						display: [ :commit | commit summary ].
					(self createPackageDiffsTable: composite)
						display: [ :commit | self getPackageDiffsOfCommit: commit ].
					(self createClassDiffsTable: composite)
						display: [ :commit | self getClassDiffsOfCommit: commit ].
					(self createMethodDiffsTable: composite)
						display: [ :commit | self getMethodDiffsOfCommit: commit ] ] ]
]

{ #category : #'instance creation' }
SPGitLatestCommitsBrowser >> open [

	| list |
	
	list := self context gitRepo getLatestCommits: 500.
	self createBrowser openOn: list
]
