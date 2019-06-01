Class {
	#name : #SPCheckClassComments,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #execution }
SPCheckClassComments >> execute [

	| batch lastId |
	
	lastId := -1.
	[ 
		batch := self readBatch: 250 last: lastId.
		batch notEmpty
			ifTrue: [  
				self glorpSession inTransactionDo: [ 
					self processBatch: batch ].
				lastId := batch last id ].
		batch notEmpty ] whileTrue.
]

{ #category : #execution }
SPCheckClassComments >> processBatch: aList [

	aList do: [ :eachClass |
		| comment cleanComment |
		comment := eachClass comment.
		cleanComment := SPClassBuilder cleanUpString: comment.
		comment = cleanComment 
			ifFalse: [ 
				eachClass updateComment: cleanComment.
				self classRepo updateCommentAndHash: eachClass.
				self logInfo: 'Updated comment for class ', eachClass name ] ]
]

{ #category : #execution }
SPCheckClassComments >> readBatch: batchSize last: lastId [

	| q |
	
	q := (Query read: SPGlorpClass where: [ :e | e id > lastId ])
		orderBy: [ :e | e id ];
		limit: batchSize;
		yourself.
		
	^ self glorpSession execute: q
]
