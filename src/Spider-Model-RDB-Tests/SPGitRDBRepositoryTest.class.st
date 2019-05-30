Class {
	#name : #SPGitRDBRepositoryTest,
	#superclass : #SPiderTestCase,
	#instVars : [
		'lgitRepo'
	],
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #running }
SPGitRDBRepositoryTest >> createContext [

	^ SPiderContextTestResource current context
]

{ #category : #accessing }
SPGitRDBRepositoryTest >> createLGitRepo [

	^ (LGitRepository on: SPGitCommitLGitBuilderTest baseDirectory asFileReference / 'Spider-GitTest')
			open;
			yourself
]

{ #category : #accessing }
SPGitRDBRepositoryTest >> lgitRepo [
	^ lgitRepo
]

{ #category : #running }
SPGitRDBRepositoryTest >> setUp [

	super setUp.
	SPiderContextTestResource current resetForGit.
	
	lgitRepo := self createLGitRepo.
]

{ #category : #running }
SPGitRDBRepositoryTest >> tearDown [

	context := nil.
	super tearDown
]

{ #category : #accessing }
SPGitRDBRepositoryTest >> testStoreCommit1 [

	| commit builder spCommit spCommitRead |

	commit := self lgitRepo revparse: '82a2d28'.
	builder := SPLibGitCommitBuilder new
		setContext: self context;
		commit: commit;
		yourself.
	spCommit := builder build.

	spCommitRead := self gitRepo getCommitBySha: spCommit sha ifAbsent: [ nil ].
	self assert: spCommitRead notNil.
	self assert: spCommit ~~ spCommitRead.
	
	self assert: spCommitRead sha equals: spCommit sha.
	self assert: spCommitRead datetime equals: spCommit datetime.
	self assert: spCommitRead message equals: spCommit message.
	self assert: spCommitRead sourceDir equals: spCommit sourceDir.
	self assert: spCommitRead format equals: spCommit format.



	
]

{ #category : #accessing }
SPGitRDBRepositoryTest >> testStoreCommit2 [

	| commit builder spCommit |

	commit := self lgitRepo revparse: '3035b8e'.
	builder := SPLibGitCommitBuilder new
		setContext: self context;
		commit: commit;
		yourself.
	spCommit := builder build.

]
