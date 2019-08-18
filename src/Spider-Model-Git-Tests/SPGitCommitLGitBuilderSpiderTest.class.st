Class {
	#name : #SPGitCommitLGitBuilderSpiderTest,
	#superclass : #SPGitCommitLGitBuilderTest,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> createLGitRepo [

	^ self createLGitRepo: 'https://github.com/jvdsandt/spider-gittest.git'
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
	
	self assert: spCommit1 equals: spCommit2
	
	


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

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit3 [

	| spCommit spClass |

	spCommit := SPLibGitCommitBuilder new
		setContext: self context;
		commit: (self lgitRepo revparse: '6806341');
		build.
	
	self assert: spCommit message equals: 'Added class method to SpiderGitDemoClass'.
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).

	spClass := spCommit packages first classNamed: #SpiderGitDemoClass.
	self assert: spClass classSelectors equals: #( maxAge ).

]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit4 [

	| spCommit spClassExt |

	spCommit := SPLibGitCommitBuilder new
		setContext: self context;
		commit: (self lgitRepo revparse: '8f9a029');
		build.
	
	self assert: spCommit message equals: 'Added Date class extension'.
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).

	spClassExt := spCommit packages first classExtensionNamed: #Date.
	self assert: spClassExt classSelectors equals: #( spiderDemoMethod ).

]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit5 [

	| spCommit spPackage |

	spCommit := SPLibGitCommitBuilder new
		setContext: self context;
		commit: (self lgitRepo revparse: 'c80b1fe');
		build.
	
	self assert: spCommit message equals: 'Removed Date class extension'.
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).

	spPackage := spCommit packages first.
	self assert: spPackage classNames equals: #( SpiderGitDemoClass ).
	self assert: spPackage classExtensionNames equals: #().
]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit6 [

	| spCommit |

	spCommit := SPLibGitCommitBuilder new
		setContext: self context;
		commit: (self lgitRepo revparse: 'a938376');
		build.
	
	self assert: spCommit message trimRight equals: 'Moved code to src directory'.
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).
	self assert: spCommit sourceDir equals: 'src'.

	self assert: spCommit parents first packages equals: spCommit packages
]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit7 [

	| spCommit spClass |

	spCommit := SPLibGitCommitBuilder new
		setContext: self context;
		commit: (self lgitRepo revparse: '71ea4ec');
		build.
	
	self assert: spCommit message trimRight equals: 'Added second package and added class comments.'.
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' 'Spider-GitDemo2' ).
	self assert: spCommit sourceDir equals: 'src'.

	spClass := (spCommit packageNamed: #'Spider-GitDemo1') classNamed: #SpiderGitDemoClass.
	self assert: 'This is just a useless demo class!' equals: spClass comment.
	
	spClass := (spCommit packageNamed: #'Spider-GitDemo2') classNamed: #SpiderGitDemoClass2.
	self assert: 'This is just another useless demo class!' equals: spClass comment.
]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderTest >> testBuildCommit8 [

	| spCommit |

	spCommit := SPLibGitCommitBuilder new
		setContext: self context;
		commit: (self lgitRepo revparse: 'c336436');
		build.
	
	self assert: spCommit message trimRight equals: 'Removed second package'.
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).

]
