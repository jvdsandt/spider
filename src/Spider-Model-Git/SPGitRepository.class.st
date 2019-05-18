Class {
	#name : #SPGitRepository,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Git-Repos'
}

{ #category : #initialization }
SPGitRepository >> setContext: aSpiderContext [

	context := aSpiderContext
]
