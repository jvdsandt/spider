Class {
	#name : #SPGitCommit,
	#superclass : #Object,
	#instVars : [
		'sha',
		'author',
		'datetime',
		'message',
		'parents',
		'packages'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #accessing }
SPGitCommit >> author [
	^ author
]

{ #category : #accessing }
SPGitCommit >> authorEmail [
	^ self author email
]

{ #category : #accessing }
SPGitCommit >> authorName [
	^ self author name
]

{ #category : #accessing }
SPGitCommit >> datetime [
	^ datetime
]

{ #category : #accessing }
SPGitCommit >> gitId [

	^ sha hex
]

{ #category : #initialization }
SPGitCommit >> initWithSha: shaHash author: anAuthor datetime: aDateTime message: aMessage parents: aParents packages: aPackages [

	sha := shaHash.
	author := anAuthor.
	datetime := aDateTime.
	message := aMessage.
	parents := aParents asArray.
	packages := aPackages asArray
]

{ #category : #accessing }
SPGitCommit >> message [
	^ message
]

{ #category : #accessing }
SPGitCommit >> packageNames [

	^ self packages collect: [ :each | each name ]
]

{ #category : #accessing }
SPGitCommit >> packages [
	^ packages
]

{ #category : #accessing }
SPGitCommit >> parents [
	^ parents
]

{ #category : #printing }
SPGitCommit >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	aStream nextPutAll: ((sha last: 4) hex first: 7).
	aStream nextPut: $)
]

{ #category : #accessing }
SPGitCommit >> sha [
	^ sha
]
