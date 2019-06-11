Class {
	#name : #SPGitRepoToCommitRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'name',
		'commit'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #accessing }
SPGitRepoToCommitRef >> commit [
	^ commit
]

{ #category : #accessing }
SPGitRepoToCommitRef >> datetime [

	^ self commit datetime
]

{ #category : #accessing }
SPGitRepoToCommitRef >> name [
	^ name
]
