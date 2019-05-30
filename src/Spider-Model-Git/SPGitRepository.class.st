Class {
	#name : #SPGitRepository,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Git-Repos'
}

{ #category : #accessing }
SPGitRepository >> packageRepo [
	^ context packageRepo
]

{ #category : #initialization }
SPGitRepository >> setContext: aSpiderContext [

	context := aSpiderContext
]

{ #category : #accessing }
SPGitRepository >> transactionId [

	^ context currentTransactionId
]
