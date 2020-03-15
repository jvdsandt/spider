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
		yourself
]
