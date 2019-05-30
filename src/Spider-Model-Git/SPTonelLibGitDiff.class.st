Class {
	#name : #SPTonelLibGitDiff,
	#superclass : #SPGitLibGitDiff,
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'as yet unclassified' }
SPTonelLibGitDiff >> packageNameFromPath: aPath [

	^ aPath readStream upTo: $/
]
