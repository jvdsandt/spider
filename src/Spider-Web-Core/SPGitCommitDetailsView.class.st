Class {
	#name : #SPGitCommitDetailsView,
	#superclass : #SPDetailsView,
	#instVars : [
		'gitCommit'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPGitCommitDetailsView >> gitCommit [
	^ gitCommit
]

{ #category : #accessing }
SPGitCommitDetailsView >> gitCommit: anObject [
	gitCommit := anObject
]

{ #category : #rendering }
SPGitCommitDetailsView >> renderContentOn: html [

	self renderTitle: 'Git commit details' on: html. 

	self renderLabel: 'sha' value: self gitCommit shaString on: html.
	self renderLabel: 'Author' value: self gitCommit authorName on: html.
	self renderLabel: 'Datetime' value: self gitCommit datetime on: html.

	html paragraph: [ 
		html text: 'Message: '.
		html preformatted
			style: 'white-space: pre-wrap;';
			with: self gitCommit message ].
		
	self renderParentsOn: html.

	self gitCommit packages notEmpty
		ifTrue: [ 
			html anchor 
				callback: [ self openBrowserOnPackages: self gitCommit packages ];
				with: 'Browse' ]
]

{ #category : #rendering }
SPGitCommitDetailsView >> renderParentsOn: html [

	self gitCommit parents isEmpty
		ifTrue: [ ^ self ].
		
	html paragraph: [ 
		html text: 'Parents(s): '.
		self gitCommit parents 
			do: [ :each |
				html anchor
					callback: [ self openGitCommit: each ];
					with: each shaShortString ]
			separatedBy: [ html space ] ]
]
