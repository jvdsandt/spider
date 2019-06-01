Class {
	#name : #SPRehashClasses,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #'as yet unclassified' }
SPRehashClasses >> execute [

	| batch lastId |
	
	lastId := -1.
	[ 
		batch := self readBatch: 100 last: lastId.
		batch notEmpty
			ifTrue: [  
				self glorpSession inTransactionDo: [ 
					self processBatch: batch ].
				lastId := batch last id ].
		batch notEmpty ] whileTrue.
]

{ #category : #'as yet unclassified' }
SPRehashClasses >> processBatch: aList [

	aList do: [ :each |
		| oldHash |
		oldHash := each classHash.
		each initClassHash.
		each classHash = oldHash 
			ifFalse: [ self classRepo updateHash: each ] ].
		
	self logInfo: aList size printString, ' class hashes updated'
]

{ #category : #'as yet unclassified' }
SPRehashClasses >> readBatch: batchSize last: lastId [

	| q |
	
	q := (Query read: SPGlorpClass where: [ :e | e id > lastId ])
		orderBy: [ :e | e id ];
		limit: batchSize;
		yourself.
		
	^ self glorpSession execute: q
]
