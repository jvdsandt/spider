Class {
	#name : #SPGitCommitIceBuilderTest,
	#superclass : #SPiderTestCase,
	#instVars : [
		'iceRepo'
	],
	#classVars : [
		'BaseDirectory'
	],
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitCommitIceBuilderTest class >> baseDirectory [

	^ BaseDirectory ifNil: [ '' ]
]

{ #category : #accessing }
SPGitCommitIceBuilderTest class >> baseDirectory: aString [

	BaseDirectory := aString
]

{ #category : #accessing }
SPGitCommitIceBuilderTest >> createIceRepo [

	self subclassResponsibility
]

{ #category : #accessing }
SPGitCommitIceBuilderTest >> iceRepo [

	^ iceRepo ifNil: [ iceRepo := self createIceRepo ]
]
