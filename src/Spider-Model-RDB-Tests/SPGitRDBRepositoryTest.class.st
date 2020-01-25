Class {
	#name : #SPGitRDBRepositoryTest,
	#superclass : #SPGitCommitLGitBuilderSpiderTest,
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #accessing }
SPGitRDBRepositoryTest >> createContext [

	^ SPiderContextTestResource current context
]

{ #category : #running }
SPGitRDBRepositoryTest >> setUp [

	super setUp.
	SPiderContextTestResource current resetForGit
]

{ #category : #running }
SPGitRDBRepositoryTest >> tearDown [

	context := nil.
	super tearDown
]

{ #category : #running }
SPGitRDBRepositoryTest >> testCreateRepo [

	| url repo repoRead |

	url := 'https://github.com/jvdsandt/spider-gittest.git'.
	repo := SPGitRepo url: url.
	self gitRepo storeRepo: repo.
	
	repoRead := self gitRepo getRepoByUrl: url ifAbsent: [ nil ].
	self assert: repoRead equals: repo.

	repoRead := self gitRepo getRepo: 'GitHub' owner: 'jvdsandt' name: 'spider-gittest' ifAbsent: [ nil ].
	self assert: repoRead equals: repo.
	
]
