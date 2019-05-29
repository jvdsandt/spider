Class {
	#name : #SPGitCommitLGitBuilderPharoTest,
	#superclass : #SPGitCommitLGitBuilderTest,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitCommitLGitBuilderPharoTest >> createLGitRepo [

	^ (LGitRepository on: self class baseDirectory asFileReference / 'pharo.git')
			open;
			yourself
			
]

{ #category : #accessing }
SPGitCommitLGitBuilderPharoTest >> testBranches [

	self lgitRepo branchNames inspect
]

{ #category : #accessing }
SPGitCommitLGitBuilderPharoTest >> testCodeReader [

	| commit reader |
	
	commit := self lgitRepo revparse: 'Pharo6.1'.
	reader := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		codeReader.
	self assert: reader packageNames asArray equals: #( 'P3' ).

	commit := self lgitRepo revparse: '0da83ab'.
	reader := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		codeReader.
	self assert: reader packageNames asArray equals: #( 'BaselineOfP3' 'P3-Glorp' 'P3' ).

]

{ #category : #accessing }
SPGitCommitLGitBuilderPharoTest >> testFormatResolver [

	| commit resolver |
	
	"first commit without st code"
	commit := self lgitRepo revparse: 'b3e74a1'.
	resolver := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		yourself.
	self assert: resolver sourceDirectory isNil.
	self assert: resolver format isNil.
	self deny: resolver packagesPresent.
	
	commit := self lgitRepo revparse: '8a1f250'.
	resolver := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		yourself.
	self assert: resolver sourceDirectory equals: '/'.
	self assert: resolver format equals: #filetree.
	self assert: resolver packagesPresent.
	
	"7.0.3"
	commit := self lgitRepo revparse: 'v7.0.3'.
	resolver := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		yourself.
	self assert: resolver sourceDirectory equals: 'src'.
	self assert: resolver format equals: #tonel.
	self assert: resolver packagesPresent.

]

{ #category : #accessing }
SPGitCommitLGitBuilderPharoTest >> testIsBase [

	self assert: self lgitRepo isBare
]
