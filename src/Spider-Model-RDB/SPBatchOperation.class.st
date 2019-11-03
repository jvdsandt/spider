Class {
	#name : #SPBatchOperation,
	#superclass : #Object,
	#instVars : [
		'context',
		'queries'
	],
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #accessing }
SPBatchOperation >> classRepo [

	^ self context classRepo
]

{ #category : #accessing }
SPBatchOperation >> context [
	^ context
]

{ #category : #accessing }
SPBatchOperation >> context: anObject [
	context := anObject
]

{ #category : #actions }
SPBatchOperation >> deleteCommit: aCommit [
	"Delete <aCommit> and all commits that are based on it (all its children recursively)"

	self context 
		doTransaction: self class name, ' - Deleting commit ', aCommit shaString
		with: [ self deleteCommit: aCommit txid: self context currentTransactionId ]
]

{ #category : #actions }
SPBatchOperation >> deleteCommit: aCommit txid: txid [
	"Delete <aCommit> and all commits that are based on it (all its children recursively)"

	| statement result |
	
	statement := self p3client format: 'SELECT count(*) FROM git_commits WHERE id = $1'.
	result := statement query: (Array with: aCommit id).
	result firstRecord first = 0
		ifTrue: [ ^ self ].	

	aCommit children do: [ :each |
		self deleteCommit: each txid: txid ].
	
	statement := self p3client format: 'DELETE FROM git_repo_refs WHERE commit_id = $1'.
	statement execute: (Array with: aCommit id).
	
	statement := self p3client format: 'DELETE FROM git_repo_commits WHERE commit_id = $1'.
	statement execute: (Array with: aCommit id).

	statement := self p3client format: 'DELETE FROM git_commit_pack_refs WHERE commit_id = $1'.
	statement execute: (Array with: aCommit id).

	statement := self p3client format: 'DELETE FROM git_commit_parent_refs WHERE commit_id = $1'.
	statement execute: (Array with: aCommit id).

	statement := self p3client format: 'DELETE FROM git_commits WHERE id = $1'.
	statement execute: (Array with: aCommit id).
	
]

{ #category : #accessing }
SPBatchOperation >> gitRepo [

	^ self context gitRepo
]

{ #category : #accessing }
SPBatchOperation >> glorpSession [

	^ self context glorpSession
]

{ #category : #initialization }
SPBatchOperation >> initialize [

	super initialize.
	
	context := SPCurrentContext value
]

{ #category : #accessing }
SPBatchOperation >> p3client [

	^ self context client
]

{ #category : #accessing }
SPBatchOperation >> p3prepare: sqlString [

	^ self queries at: sqlString ifAbsentPut: [ queries createQuery: sqlString ]
]

{ #category : #accessing }
SPBatchOperation >> packageRepo [

	^ self context packageRepo
]

{ #category : #accessing }
SPBatchOperation >> queries [

	^ queries ifNil: [ queries := SPP3Queries new initWithClient: self p3client ]
]

{ #category : #execution }
SPBatchOperation >> rehashPackageIds: aList txid: txid [

	aList do: [ :eachId |
		| package oldHash |
		package := self packageRepo getPackageById: eachId.
		oldHash := package packageHash.
		package initPackageHash.
		package packageHash = oldHash 
			ifFalse: [ self packageRepo updateHash: package ] ].
		
	self logInfo: aList size printString, ' package hashes updated'
]

{ #category : #initialization }
SPBatchOperation >> reset [

	self context glorpSession reset
]
