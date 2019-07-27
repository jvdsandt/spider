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
SPGitCommitDetailsView >> renderChildrenOn: html [

	| children |
	
	children := self context gitRepo selectChildrenOf: self gitCommit id.
	children isEmpty
		ifTrue: [ ^ self ].
		
	html paragraph: [ 
		html text: 'Children: '.
		children
			do: [ :each |
				html anchor
					url: (self router pathForGitCommit: each);
					with: each shaShortString ]
			separatedBy: [ html space ] ]
]

{ #category : #rendering }
SPGitCommitDetailsView >> renderContentOn: html [

	self renderTitle: 'Git commit details' on: html. 
	self renderRefsOn: html.

	self renderLabel: 'sha' value: self gitCommit shaString on: html.
	self renderLabel: 'Author' value: self gitCommit authorName on: html.
	self renderLabel: 'Datetime' value: self gitCommit datetime on: html.

	html paragraph: [ 
		html text: 'Message: '.
		html preformatted
			style: 'white-space: pre-wrap;';
			with: self gitCommit message ].
		
	self renderParentsOn: html.
	self renderChildrenOn: html.

	self gitCommit packages notEmpty
		ifTrue: [ 
			html anchor 
				url: (self router pathForGitCommitBrowser: self gitCommit);
				with: 'Browse' ].
			
	self renderDiffsOn: html.
			
		
]

{ #category : #rendering }
SPGitCommitDetailsView >> renderDiffsOn: html [

	| diffs |
	
	diffs := self gitCommit diffs.
	diffs isEmpty
		ifTrue: [ 
			html paragraph: 'No changed packages'.
			^ self ].
		
	html render: (SPDiffsComponent new
		diffs: diffs;
		yourself)
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
					url: (self router pathForGitCommit: each);
					with: each shaShortString ]
			separatedBy: [ html space ] ]
]

{ #category : #rendering }
SPGitCommitDetailsView >> renderRefsOn: html [

	| refs |
	
	refs := self gitRepo selectRepoRefsOfCommit: self gitCommit id.
	refs isEmpty
		ifTrue: [ ^ self ].
		
	(refs select: [ :each | each isBranch ]) do: [ :each |
		html span
			class: 'label label-primary';
			with: each name.
		html space ].
		
	(refs select: [ :each | each isTag ]) do: [ :each |
		html span 
			class: 'label label-success';
			with: each name.
		html space ]
]

{ #category : #updating }
SPGitCommitDetailsView >> updateUrl: anUrl [

	super updateUrl: anUrl.
	anUrl
		addToPath: 'git_commit';
		addToPath: self gitCommit shaString
	

]
