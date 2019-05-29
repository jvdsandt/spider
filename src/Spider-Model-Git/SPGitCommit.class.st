Class {
	#name : #SPGitCommit,
	#superclass : #SPGlorpNode,
	#instVars : [
		'sha',
		'authorSignature',
		'message',
		'parents',
		'packages',
		'sourceDir',
		'format'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #'instance creation' }
SPGitCommit class >> sha: shaHash authorSignature: anAuthorSig message: aMessage parents: aParents packages: aPackages sourceDir: aDir format: aFormat [

	^ self new initWithSha: shaHash 
			authorSignature: anAuthorSig 
			message: aMessage 
			parents: aParents 
			packages: aPackages 
			sourceDir: aDir 
			format: aFormat
]

{ #category : #accessing }
SPGitCommit >> authorEmail [
	^ self authorSignature email
]

{ #category : #accessing }
SPGitCommit >> authorName [
	^ self authorSignature name
]

{ #category : #accessing }
SPGitCommit >> authorSignature [
	^ authorSignature
]

{ #category : #accessing }
SPGitCommit >> datetime [
	^ self authorSignature datetime
]

{ #category : #accessing }
SPGitCommit >> gitId [

	^ sha hex
]

{ #category : #initialization }
SPGitCommit >> initWithSha: shaHash authorSignature: anAuthorSig message: aMessage parents: aParents packages: aPackages sourceDir: aDir format: aFormat [

	sha := shaHash.
	authorSignature := anAuthorSig.
	message := aMessage.
	parents := aParents asArray.
	packages := aPackages asArray.
	sourceDir := aDir.
	format := aFormat
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
