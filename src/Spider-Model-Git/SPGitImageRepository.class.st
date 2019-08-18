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
SPGitImageRepository >> getCommitByShaString: aString ifAbsent: aBlock [

	^ self commits at: aString ifAbsent: aBlock
]

{ #category : #accessing }
SPGitImageRepository >> storeCommit: aCommit [

	^ self commits at: aCommit shaString put: aCommit
]
