Class {
	#name : #SPGitRepoBrowser,
	#superclass : #SPGlamourGitBrowser,
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #'as yet unclassified' }
SPGitRepoBrowser >> createBrowser [

	^ GLMCompositePresentation new tabulator 
			with: [ :t |
				t title: 'Spider Repo Browser'.
				t 
					column: #repos span: 2; 
					column: #repoRefs span: 1;
					column: #commits span: 3.
				t transmit to: #repos; andShow: [ :composite | 
					composite list 
						title: 'Git Repositories';
						format: [ :each | each url ] ].
				t transmit from: #repos; to: #repoRefs; andShow: [ :composite |
					composite list
						title: 'Branches';
						display: [ :repo | repo mostRecentBranches: 250 ];
						format: [ :eachRef | eachRef name ].
					composite list
						title: 'Tags';
						display: [ :repo | repo mostRecentTags: 250 ];
						format: [ :eachRef | eachRef name ] ].
				t transmit from: #repoRefs; to: #commits; andShow: [ :composite |
					(self createCommitsTable: composite)
						display: [ :repoRef | repoRef allCommitsMax: 10 ] ] ]
]

{ #category : #'as yet unclassified' }
SPGitRepoBrowser >> open [

	| list |
	
	list := self context gitRepo getRepos: SPStringSearchCriteria new max: 500.
	self createBrowser openOn: list
]
