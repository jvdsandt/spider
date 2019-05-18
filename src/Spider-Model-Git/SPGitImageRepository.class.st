Class {
	#name : #SPGitImageRepository,
	#superclass : #SPGitRepository,
	#instVars : [
		'commits'
	],
	#category : #'Spider-Model-Git-Repos'
}

{ #category : #accessing }
SPGitImageRepository >> commits [

	^ commits ifNil: [ commits := Dictionary new ]
]

{ #category : #accessing }
SPGitImageRepository >> storeCommit: aCommit [

	^ self commits at: aCommit sha put: aCommit
]
