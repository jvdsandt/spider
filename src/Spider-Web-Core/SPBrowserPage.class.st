Class {
	#name : #SPBrowserPage,
	#superclass : #SPPage,
	#instVars : [
		'mainPanel'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #'tools registry' }
SPBrowserPage class >> register [

	| app |
	
	app := WAAdmin register: self asApplicationAt: 'spider-browser'.
	

]

{ #category : #hooks }
SPBrowserPage >> initialRequest: aRequest [

	| commitSha |
	
	super initialRequest: aRequest.
	
	commitSha := aRequest at: 'commit' ifAbsent: [ nil ].
	commitSha notNil
		ifTrue: [ 
			| commit |
			commit :=  self gitRepo getCommitByShaString: commitSha ifAbsent: [ nil ].
			commit notNil
				ifTrue: [ 
					mainPanel := SPBrowserComponent onGitCommit: commit ] ].
			

]

{ #category : #rendering }
SPBrowserPage >> renderContentOn: html [

	html tbsContainer: [ 
		html render: mainPanel ]
		
	
]
