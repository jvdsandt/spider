Class {
	#name : #SPGitLibGitDiff,
	#superclass : #Object,
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'as yet unclassified' }
SPGitLibGitDiff >> initWithOld: oldCommit oldSourceDir: oldPath new: newCommit newSourceDir: newPath [

	| oldTree newTree diff |
	
	oldTree := oldCommit tree.
	oldPath isEmptyOrNil
		ifFalse: [ oldTree := oldTree entryByPath: oldPath ].
		
	newTree := newCommit tree.
	newPath isEmptyOrNil
		ifFalse: [ newTree := newTree entryByPath: newPath ].
		
	diff := oldTree diffTo: newTree.
	diff filesDo: [ :delta :second :third |
		self handleDelta: delta.
		0 ].
	
	
]
