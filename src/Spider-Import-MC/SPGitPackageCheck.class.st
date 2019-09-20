Class {
	#name : #SPGitPackageCheck,
	#superclass : #Object,
	#instVars : [
		'name',
		'treeSha',
		'oldestCommitSha',
		'oldestCommitDatetime',
		'newestCommitSha',
		'newestCommitDateTime',
		'errorMessage',
		'count'
	],
	#category : #'Spider-Import-MC-Checks'
}

{ #category : #accessing }
SPGitPackageCheck >> errorMessage [
	^ errorMessage
]

{ #category : #actions }
SPGitPackageCheck >> handleLGitCommit: aCommit [ 

	| dt |
	
	dt := aCommit time asDateAndTime.

	(oldestCommitDatetime isNil or: [ oldestCommitDatetime > dt ])
		ifTrue: [ 
			oldestCommitSha := aCommit id hexString.
			oldestCommitDatetime := dt ].
		
	(newestCommitDateTime isNil or: [ newestCommitDateTime < dt ])
		ifTrue: [ 
			newestCommitSha := aCommit id hexString.
			newestCommitDateTime := dt ].
		
	count := count + 1
]

{ #category : #initialization }
SPGitPackageCheck >> initWithName: aString treeSha: aShaString [

	name := aString.
	treeSha := aShaString.
	count := 0
]

{ #category : #testing }
SPGitPackageCheck >> isOk [

	^ errorMessage isNil
]

{ #category : #accessing }
SPGitPackageCheck >> name [
	^ name
]

{ #category : #accessing }
SPGitPackageCheck >> newestCommitDateTime [
	^ newestCommitDateTime
]

{ #category : #accessing }
SPGitPackageCheck >> newestCommitSha [
	^ newestCommitSha
]

{ #category : #accessing }
SPGitPackageCheck >> oldestCommitDatetime [
	^ oldestCommitDatetime
]

{ #category : #accessing }
SPGitPackageCheck >> oldestCommitSha [
	^ oldestCommitSha
]

{ #category : #initialization }
SPGitPackageCheck >> setErrorMessage: aString [

	errorMessage := aString
]

{ #category : #accessing }
SPGitPackageCheck >> treeSha [
	^ treeSha
]
