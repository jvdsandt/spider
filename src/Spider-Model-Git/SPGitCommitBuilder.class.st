Class {
	#name : #SPGitCommitBuilder,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #initialization }
SPGitCommitBuilder >> setContext: aContext [

	context := aContext 
]
