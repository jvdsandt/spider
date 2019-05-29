Class {
	#name : #SPGitCommitBuilder,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #acccessing }
SPGitCommitBuilder >> context [

	^ context
]

{ #category : #acccessing }
SPGitCommitBuilder >> gitRepo [

	^ self context gitRepo
]

{ #category : #initialization }
SPGitCommitBuilder >> setContext: aContext [

	context := aContext 
]
