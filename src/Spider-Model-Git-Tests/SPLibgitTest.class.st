Class {
	#name : #SPLibgitTest,
	#superclass : #TestCase,
	#instVars : [
		'lgitRepo'
	],
	#classVars : [
		'BaseDirectory'
	],
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPLibgitTest class >> baseDirectory [

	^ BaseDirectory
]

{ #category : #accessing }
SPLibgitTest class >> baseDirectory: aString [

	BaseDirectory := aString
]

{ #category : #'as yet unclassified' }
SPLibgitTest >> createLgitRepo [

	^ (LGitRepository on: self class baseDirectory asFileReference / 'P3')
			open;
			yourself

]

{ #category : #'as yet unclassified' }
SPLibgitTest >> lgitRepo [

	^lgitRepo ifNil: [ lgitRepo := self createLgitRepo ]
]

{ #category : #'as yet unclassified' }
SPLibgitTest >> logDiffsBetween: oldTree and: newTree [

	| diff |
	
	diff := (LGitDiff of: self lgitRepo) diffTree: oldTree toTree: newTree.
	diff filesDo: [ :delta :second :third |
		Transcript cr; show: delta newFile path.
		0 "Continue" ]
]

{ #category : #'as yet unclassified' }
SPLibgitTest >> testDiff [

	| lastCommit prevCommits |
	
	lastCommit := self lgitRepo allBranches first object.
	self assert: lastCommit isCommit.
	
	[ prevCommits := lastCommit parents. prevCommits isEmpty ]
		whileFalse: [ 
			self logDiffsBetween: prevCommits first tree and: lastCommit tree.
			Transcript cr; show: '-------------------------------------------------------------------------'; flush ]
]
