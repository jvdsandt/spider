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

{ #category : #comparing }
SPGitRepoToCommitRef >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ name = other name and: [ type = other type and: [ commit = other commit ] ]
]

{ #category : #accessing }
SPGitRepoToCommitRef >> allCommitsAfter: aDatetime [

	^ self commit withAllParentsAfter: aDatetime
]

{ #category : #accessing }
SPGitRepoToCommitRef >> commit [
	^ commit
]

{ #category : #accessing }
SPGitRepoToCommitRef >> datetime [

	^ self commit datetime
]

{ #category : #comparing }
SPGitRepoToCommitRef >> hash [

	^ name hash bitXor: commit hash
]

{ #category : #accessing }
SPGitRepoToCommitRef >> historyList: maxSize [
	^ self commit historyList: maxSize
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
