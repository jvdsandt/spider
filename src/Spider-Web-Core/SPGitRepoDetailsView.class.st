Class {
	#name : #SPGitRepoDetailsView,
	#superclass : #SPDetailsView,
	#instVars : [
		'gitRepo'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPGitRepoDetailsView >> gitRepo [
	^ gitRepo
]

{ #category : #accessing }
SPGitRepoDetailsView >> gitRepo: anObject [
	gitRepo := anObject
]

{ #category : #rendering }
SPGitRepoDetailsView >> renderBrowserOn: html [

	| commit |
	
	commit := self gitRepo mostRecentCommit.
	(commit isNil or: [ commit packages isEmpty ])
		ifTrue: [ ^ self ].
		
	html render: (SPBrowserComponent onGitCommit: commit)
]

{ #category : #rendering }
SPGitRepoDetailsView >> renderContentOn: html [

	html heading
		level: 3;
		with: [ 
			html 
				text: self gitRepo domain;
				text: ' / ';
				text: self gitRepo owner;
				text: ' / ';
				text: self gitRepo name ].

	self renderBrowserOn: html
]
