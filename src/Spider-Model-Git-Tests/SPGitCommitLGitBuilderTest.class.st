Class {
	#name : #SPGitCommitLGitBuilderTest,
	#superclass : #SPiderTestCase,
	#instVars : [
		'lgitRepo'
	],
	#classVars : [
		'BaseDirectory'
	],
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitCommitLGitBuilderTest class >> baseDirectory [

	^ BaseDirectory ifNil: [ '/Users/jan/Projects' ]
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest class >> baseDirectory: anObject [

	BaseDirectory := anObject
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest >> createLGitRepo [

	self subclassResponsibility
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest >> lgitRepo [

	^ lgitRepo ifNil: [ lgitRepo := self createLGitRepo ]
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest >> testIsBase [

	self assert: self lgitRepo isBare
]
