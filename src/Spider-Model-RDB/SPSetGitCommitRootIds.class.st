Class {
	#name : #SPSetGitCommitRootIds,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #example }
SPSetGitCommitRootIds >> example [
	"SPWebContext default do: [ self new example ]"

	| repo |
	
	repo := self gitRepo getGitRepoByUrl: 'https://github.com/pharo-nosql/voyage.git' ifAbsent: [ nil ].
	
	self executeForRepo: repo. 
]

{ #category : #executing }
SPSetGitCommitRootIds >> execute [
	"SPWebContext default do: [ self new execute ]"

	| repos |
	
	repos := self glorpSession read: SPGitRepo.
	self logInfo: 'Found ', repos size asString, ' fit repos.'.
	
	repos do: [ :each | self executeForRepo: each ]
]

{ #category : #executing }
SPSetGitCommitRootIds >> executeForCommit: aCommit alreadySeen: aSet [

	| parentIds |
	
	(aCommit rootId notNil or: [ aSet includes: aCommit ])
		ifTrue: [ ^ self ].
		
	self logInfo: 'Checking commit ', aCommit  shaShortString.
	aSet add: aCommit.
		
	aCommit parents do: [ :each | self executeForCommit: each  alreadySeen: aSet ].
	parentIds := ((aCommit parents collect: #rootId) reject: #isNil) asSet.

	parentIds size = 1
		ifTrue: [ 
			self setRootIdOf: aCommit to: parentIds anyOne.
			^ self ].
		
	parentIds isEmpty
		ifTrue: [ 
			aCommit hasPackages 
				ifTrue: [ self setRootIdOf: aCommit to: (self gitRepo storeCommitRoot: aCommit shaString) ].
			^ self ].

	self setRootIdOf: aCommit to: (self gitRepo mergeCommitRoots: parentIds)
]

{ #category : #executing }
SPSetGitCommitRootIds >> executeForRepo: aGitRepo [

	aGitRepo commitRefs do: [ :each |
		(each commit rootId isNil and: [ each commit hasPackages ])
			ifTrue: [ 
				self logInfo: 'Setting rootId''s for ', aGitRepo url, ' ref: ', each name.
				self context 
					doTransaction: self class name, ' - ', aGitRepo url
					with: [ self executeForCommit: each commit alreadySeen: Set new. ].
				self glorpSession initializeCache ] ]
]

{ #category : #initialization }
SPSetGitCommitRootIds >> setRootIdOf: aCommit to: anInteger [

	| statement |

	statement := self p3client format: 'UPDATE git_commits SET root_id = $2 WHERE id = $1'.
	statement execute: (Array with: aCommit id with: anInteger).
	
	aCommit privRootId: anInteger.

]
