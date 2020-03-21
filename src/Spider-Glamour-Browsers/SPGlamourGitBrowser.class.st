Class {
	#name : #SPGlamourGitBrowser,
	#superclass : #SPGlamourBrowser,
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #'as yet unclassified' }
SPGlamourGitBrowser >> createCommitsTable: composite [ 

	^ composite fastTable
			title: 'Commits';
			column: 'Timestamp' evaluated: [ :each | each datetime ] width: 160;
			column: 'Commit' evaluated: [ :each | each shaShortString ] width: 80;
			column: 'Author' evaluated: [ :each | each authorName ] width: 160;
			column: 'Message' evaluated: [ :each | each messageLine ];
			selectionAct: [ :table :a :b :c | { table. a. b. c. } inspect ] entitled: 'Browse';
			selectionAct: [ :table | ] entitled: 'Check';
			selectionAct: [ :table | self openCommitOnWeb: table rawSelection ] entitled: 'Open on web';
			yourself
]

{ #category : #'as yet unclassified' }
SPGlamourGitBrowser >> openCommitOnWeb: aGitCommit [

	| repos |
	
	repos := self gitRepo getReposWithCommitSha: aGitCommit shaString.
	repos isEmpty
		ifTrue: [ ^ self ].

	self openRepoOnWeb: repos first commit: aGitCommit
]

{ #category : #'as yet unclassified' }
SPGlamourGitBrowser >> openRepoOnWeb: aGitRepo [

	WebBrowser openOn: aGitRepo htmlUrl
]

{ #category : #'as yet unclassified' }
SPGlamourGitBrowser >> openRepoOnWeb: aGitRepo commit: aGitCommit [

	WebBrowser openOn: (aGitRepo htmlUrlForSha: aGitCommit shaString)
]
