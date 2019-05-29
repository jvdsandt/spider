Class {
	#name : #SPGitCommitLGitBuilderSpiderTest,
	#superclass : #SPGitCommitLGitBuilderTest,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> createLGitRepo [

	^ (LGitRepository on: self class baseDirectory asFileReference / 'Spider-GitTest')
			open;
			yourself
			
]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit1 [

	| commit resolver builder spCommit spPackage |

	commit := self lgitRepo revparse: '82a2d28'.
	resolver := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		yourself.
		
	self assert: resolver sourceDirectory equals: ''.
	self assert: resolver format equals: #tonel.
	self assert: resolver packagesPresent.
	self assert: resolver codeReader packageNames equals: #( 'Spider-GitDemo1' ).
	
	builder := SPLibGitCommitBuilder new
		setContext: self context;
		commit: commit;
		yourself.
	spCommit := builder build.
	
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).
	self assert: spCommit authorName equals: 'Jan van de Sandt'.
	self assert: spCommit authorEmail equals: 'jan.van.de.sandt@nn.nl'.
	self assert: spCommit message equals: 'First commit with an empty package Spider-GitDemo1'.
	self assert: spCommit datetime equals: (DateAndTime fromUnixTime: 1547648749).
	self assert: spCommit authorSignature tzOffset equals: 60.
	self assert: spCommit parents isEmpty.
	self assert: spCommit packages size equals: 1.
	
	spPackage := spCommit packages first.
	self assert: spPackage name equals: 'Spider-GitDemo1'.
	self assert: spPackage classRefs isEmpty.
	
	
	


]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit1TwoTimes [

	| commit spCommit1 spCommit2 |

	commit := self lgitRepo revparse: '82a2d28'.

	spCommit1 := SPLibGitCommitBuilder new
		setContext: self context;
		commit: commit;
		build.
	spCommit2 := SPLibGitCommitBuilder new
		setContext: self context;
		commit: commit;
		build.
	
	self assert: spCommit1 == spCommit2
	
	


]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit2 [

	| commit resolver builder spCommit spPackage |

	commit := self lgitRepo revparse: '3035b8e'.
	resolver := (SPGitFormatResolver onGitCommit: commit)
		resolve;
		yourself.
		
	self assert: resolver sourceDirectory equals: ''.
	self assert: resolver format equals: #tonel.
	self assert: resolver packagesPresent.
	self assert: resolver codeReader packageNames equals: #( 'Spider-GitDemo1' ).
	
	builder := SPLibGitCommitBuilder new
		setContext: self context;
		commit: commit;
		yourself.
	spCommit := builder build.
	
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).
	self assert: spCommit authorName equals: 'Jan van de Sandt'.
	self assert: spCommit authorEmail equals: 'jan.van.de.sandt@nn.nl'.
	self assert: spCommit message equals: 'Added class SpiderGitDemoClass1'.
	self assert: spCommit datetime equals: (DateAndTime fromUnixTime: 1547648833).
	self assert: spCommit authorSignature tzOffset equals: 60.
	self assert: spCommit parents size equals: 1.
	self assert: spCommit parents first shaString equals: '82a2d283d1e0c256fd61b6e8377e52e739d854fa'.
	self assert: spCommit packages size equals: 1.
	
	spPackage := spCommit packages first.
	self assert: spPackage classNames equals: #( SpiderGitDemoClass ).
	
	
	


]
