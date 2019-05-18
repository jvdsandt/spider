Class {
	#name : #SPRehashPackages,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Uncategorized'
}

{ #category : #'as yet unclassified' }
SPRehashPackages >> execute [

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
SPRehashPackages >> processBatch: aList [

	aList do: [ :each |
		| oldHash |
		oldHash := each packageHash.
		each initPackageHash.
		each packageHash = oldHash 
			ifFalse: [ self packageRepo updateHash: each ] ].
		
	self logInfo: aList size printString, ' package hashes updated'
]

{ #category : #'as yet unclassified' }
SPRehashPackages >> readBatch: batchSize last: lastId [

	| q |
	
	q := (Query read: SPGlorpPackage where: [ :e | e id > lastId ])
		orderBy: [ :e | e id ];
		limit: batchSize;
		yourself.
		
	^ self glorpSession execute: q
]
