Class {
	#name : #SPGitCommitIceBuilderP3Test,
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
SPGitCommitIceBuilderP3Test class >> baseDirectory [

	^ BaseDirectory ifNil: [ '' ]
]

{ #category : #accessing }
SPGitCommitIceBuilderP3Test class >> baseDirectory: aString [

	BaseDirectory := aString
]

{ #category : #accessing }
SPGitCommitIceBuilderP3Test >> createIceRepo [

	self subclassResponsibility
]

{ #category : #accessing }
SPGitCommitIceBuilderP3Test >> iceRepo [

	^ iceRepo ifNil: [ iceRepo := self createIceRepo ]
]
