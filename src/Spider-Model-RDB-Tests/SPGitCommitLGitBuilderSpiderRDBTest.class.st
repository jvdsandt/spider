Class {
	#name : #SPGitCommitLGitBuilderSpiderRDBTest,
	#superclass : #SPGitCommitLGitBuilderSpiderTest,
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #testing }
SPGitCommitLGitBuilderSpiderRDBTest class >> shouldInheritSelectors [
	^ true
]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderRDBTest >> createContext [

	^ SPiderContextTestResource current context
]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderRDBTest >> setUp [

	super setUp.
	SPiderContextTestResource current resetForGit
]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderRDBTest >> tearDown [

	context := nil.
	super tearDown
]

{ #category : #accessing }
SPGitCommitLGitBuilderSpiderRDBTest >> testBuildCommit1 [

	| spCommit |
	
	super testBuildCommit1.
	
	spCommit := self gitRepo getCommitByShaString: '82a2d28' ifAbsent: [ nil ].
	self assert: spCommit notNil.
	
	spCommit := self gitRepo getCommitByShaString: '82a2d283d1e0c256fd61b6e8377e52e739d854fa' ifAbsent: [ nil ].
	self assert: spCommit notNil.
]

{ #category : #tests }
SPGitCommitLGitBuilderSpiderRDBTest >> testBuildCommit1WithRepo [

	| repo commit builder spCommit |

	repo := self gitRepo storeRepo: (SPGitRepo url: 'https://github.com/jvdsandt/spider-gittest.git').
	commit := self lgitRepo revparse: '82a2d28'.
	
	builder := SPLibGitCommitBuilder new
		setContext: self context;
		commit: commit;
		yourself.
	spCommit := builder build.
	
	self gitRepo storeCommit: spCommit for: repo.
]
