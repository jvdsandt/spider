Class {
	#name : #SPGitCommitLGitBuilderTest,
	#superclass : #SPiderTestCase,
	#instVars : [
		'lgitRepo'
	],
	#classVars : [
		'BaseDirectory'
	],
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitCommitLGitBuilderTest class >> baseDirectory [

	^ BaseDirectory ifNil: [ '/Users/jan/Projects' ]
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest class >> baseDirectory: anObject [

	BaseDirectory := anObject
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest >> createLGitRepo [

	self subclassResponsibility
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest >> createLGitRepo: aRepoUrl [

	| repoName directoryRef repo |
	
	repoName := aRepoUrl asZnUrl lastPathSegment.
	(repoName endsWith: '.git')
		ifTrue: [ repoName := repoName allButLast: 4 ].
	directoryRef := self class baseDirectory asFileReference / repoName.
	directoryRef exists 
		ifTrue: [ 
			"Assume a vlid clone is already present"
			repo := (LGitRepository on: self class baseDirectory asFileReference / repoName)
				open;
				yourself ]
		ifFalse: [ 
			"Clone the spider-gittest repo"
			directoryRef parent ensureCreateDirectory.
			repo := LGitRepository on: directoryRef.
			repo clone: aRepoUrl options: self lgitCloneOptions ].
	^ repo
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest >> lgitCloneOptions [

	^ LGitCloneOptions defaults
		fetchOptions: (LGitFetchOptions defaults
			prim_download_tags: 1;
			yourself);
		prim_bare: true;
		yourself
]

{ #category : #accessing }
SPGitCommitLGitBuilderTest >> lgitRepo [

	^ lgitRepo ifNil: [ lgitRepo := self createLGitRepo ]
]
