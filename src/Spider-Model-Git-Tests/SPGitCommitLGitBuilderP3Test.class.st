Class {
	#name : #SPGitCommitLGitBuilderP3Test,
	#superclass : #SPGitCommitLGitBuilderTest,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #'as yet unclassified' }
SPGitCommitLGitBuilderP3Test >> createLGitRepo [

	^ (LGitRepository on: self class baseDirectory asFileReference / 'P3.git')
			open;
			yourself
			
]

{ #category : #'as yet unclassified' }
SPGitCommitLGitBuilderP3Test >> testBuilder [

	| lgCommit commit builder |
	
	lgCommit := self lgitRepo revparse: 'v1.2'.

	builder := SPLibGitCommitBuilder new
		setContext: self context;
		commit: lgCommit;
		yourself.
		
	commit := builder build.
	
	self assert: commit packageNames sorted equals: #( 'BaselineOfP3' 'P3' 'P3-Glorp' 'P3-Tests' ).
]

{ #category : #'as yet unclassified' }
SPGitCommitLGitBuilderP3Test >> testCodeReader [

	| commit reader |
	
	commit := self lgitRepo revparse: '120c806'.
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

{ #category : #'as yet unclassified' }
SPGitCommitLGitBuilderP3Test >> testFileTreeSnapshot [

	| commit reader snapshot |
	
	commit := self lgitRepo revparse: '120c806'.
	reader := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		codeReader.
	snapshot := reader getPackageSnapshot: 'P3'.
	snapshot inspect 

]

{ #category : #'as yet unclassified' }
SPGitCommitLGitBuilderP3Test >> testFormatResolver [

	| commit resolver |
	
	"first commit without st code"
	commit := self lgitRepo revparse: '25b0472'.
	resolver := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		yourself.
		
	self assert: resolver sourceDirectory isNil.
	self assert: resolver format isNil.
	self deny: resolver packagesPresent.
	
	commit := self lgitRepo revparse: '120c806'.
	resolver := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		yourself.
		
	self assert: resolver sourceDirectory equals: '/'.
	self assert: resolver format equals: #filetree.
	self assert: resolver packagesPresent.

	commit := self lgitRepo revparse: '0da83ab'.
	resolver := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		yourself.

	self assert: resolver sourceDirectory equals: ''.
	self assert: resolver format equals: #tonel.
	self assert: resolver packagesPresent.

]

{ #category : #'as yet unclassified' }
SPGitCommitLGitBuilderP3Test >> testIsBase [

	self assert: self lgitRepo isBare
]

{ #category : #'as yet unclassified' }
SPGitCommitLGitBuilderP3Test >> testTonelSnapshot [

	| commit reader snapshot |
	
	commit := self lgitRepo revparse: '0da83ab'.
	reader := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		codeReader.
	snapshot := reader getPackageSnapshot: 'P3'.
	snapshot inspect 

]
