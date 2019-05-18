Class {
	#name : #SPSessionRepository,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Core-Repos'
}

{ #category : #initialization }
SPSessionRepository >> setContext: aSpiderContext [

	context := aSpiderContext
]
