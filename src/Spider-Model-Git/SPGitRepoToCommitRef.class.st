Class {
	#name : #SPGitRepoToCommitRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'type',
		'name',
		'commit'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #constants }
SPGitRepoToCommitRef class >> typeBranch [

	^ 'B'
]

{ #category : #constants }
SPGitRepoToCommitRef class >> typeTag [

	^ 'T'
]

{ #category : #accessing }
SPGitRepoToCommitRef >> commit [
	^ commit
]

{ #category : #accessing }
SPGitRepoToCommitRef >> datetime [

	^ self commit datetime
]

{ #category : #testing }
SPGitRepoToCommitRef >> isBranch [

	^ self type = self class typeBranch
]

{ #category : #testing }
SPGitRepoToCommitRef >> isTag [

	^ self type = self class typeTag
]

{ #category : #accessing }
SPGitRepoToCommitRef >> name [
	^ name
]

{ #category : #accessing }
SPGitRepoToCommitRef >> shaString [
	^ self commit shaString
]

{ #category : #accessing }
SPGitRepoToCommitRef >> type [
	^ type
]
