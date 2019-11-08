Class {
	#name : #SPCreateGitDiffRecords,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #actions }
SPCreateGitDiffRecords >> execute [
	"SPWebContext default do: [ self new execute ]"

	| batch lastId |
	
	lastId := -1.
	[ 
		batch := self readBatch: 100 last: lastId.
		batch notEmpty
			ifTrue: [  
				self processBatch: batch.
				lastId := batch last id.
				self reset ].
		batch notEmpty ] whileTrue
]

{ #category : #actions }
SPCreateGitDiffRecords >> executeForCommit: aGitCommit [

	| startTS |

	self logInfo: 'Creating diff records for git commit ',  aGitCommit shaString.
	startTS := Time millisecondClockValue.	

	self context 
		doTransaction: self class name,  ' - ',  aGitCommit shaString
		with: [ 
			| builder duration |
			builder := SPGitDiffRecordBuilder new.
			builder
				setCommit: aGitCommit;
				buildAndStoreWith: self context diffRepo.
			duration := Time millisecondClockValue - startTS.
			self logInfo: 'Created ',  builder recordCount  asString,  ' diff records in ',  duration asString,  'ms.' ]
]

{ #category : #actions }
SPCreateGitDiffRecords >> executeForNewCommits [
	"SPWebContext default do: [ self new executeForNewCommits ]"
	
	| statement result lastCommitId query commits |
	
	statement := self p3client format: 'SELECT max(commit_id) FROM diff_git_packages'.
	result := statement query: #().
	lastCommitId := result firstRecord first.

	query := Query read: SPGitCommit where: [ :e | e id > lastCommitId ].
	query 
		orderBy: [ :e | e id ];
		limit: 5000.
	commits := self glorpSession execute: query.
	
	commits do: [ :each |
		(each isImported and: [ each parents allSatisfy: [ :p | p isImported ] ])
			ifTrue: [ self executeForCommit: each ] ]
]

{ #category : #actions }
SPCreateGitDiffRecords >> processBatch: aList [

	aList do: [ :each |
		(each isImported and: [ each parents allSatisfy: [ :p | p isImported ] ])
			ifTrue: [ self executeForCommit: each ] ]
]

{ #category : #execution }
SPCreateGitDiffRecords >> readBatch: batchSize last: lastId [

	| q |
	
	q := (Query read: SPGitCommit where: [ :e | e id > lastId ])
		orderBy: [ :e | e id ];
		limit: batchSize;
		yourself.
		
	^ self glorpSession execute: q
]
