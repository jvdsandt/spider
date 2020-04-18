Class {
	#name : #SPGitRepoBrowser,
	#superclass : #SPGlamourGitBrowser,
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #private }
SPGitRepoBrowser >> createBrowser [

	^ GLMCompositePresentation new tabulator 
			with: [ :t |
				t title: 'Spider Repo Browser'.
				t row: [ :r |
					r column: #repos span: 2.
					r column: #repoRefs span: 1.
					r column: #commits span: 3 ].
				t row: [ :r |
					r column: #description ].
				t transmit to: #repos; andShow: [ :composite | 
					composite list 
						title: 'Git Repositories';
						selectionAct: [ :text | self openRepoOnWeb: text selection ] entitled: 'Open on web';
						format: [ :each | each url ] ].
				t transmit from: #repos; to: #description; andShow: [ :composite  |
					composite text
						title: 'Repositoty details';
						display: [ :repo | repo url ] ].
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
						display: [ :repoRef | repoRef allCommitsMax: 10 ] ].
				t transmit from: #commits; to: #description; andShow: [ :composite |
					composite text
						title: 'Commit Info';
						display: [ :commit | commit summary ].
					(self createPackageDiffsTable: composite)
						display: [ :commit | self getPackageDiffsOfCommit: commit ].
					(self createClassDiffsTable: composite)
						display: [ :commit | self getClassDiffsOfCommit: commit ].
					(self createMethodDiffsTable: composite)
						display: [ :commit | self getMethodDiffsOfCommit: commit ] ]
			]
]

{ #category : #'as yet unclassified' }
SPGitRepoBrowser >> open [

	| list |
	
	list := self context gitRepo getRepos: SPStringSearchCriteria new max: 500.
	self createBrowser openOn: list
]
