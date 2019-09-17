Class {
	#name : #SPGlorpDiffBuilder,
	#superclass : #Object,
	#instVars : [
		'glorpSession',
		'p3queries'
	],
	#category : #'Spider-Model-RDB'
}

{ #category : #'as yet unclassified' }
SPGlorpDiffBuilder class >> doTest [

	| instance query mcPackages |
	
	instance := self new
		glorpSession: SPWebContext default glorpSession;
		yourself.
	
	query := Query read: SPMonticelloPackage where: [ :e | e name = 'Cloudfork-AWS' ].	
	mcPackages := instance glorpSession execute: query.
	
	mcPackages do: [ :each |
		instance checkMCPackage: each ].
]

{ #category : #actions }
SPGlorpDiffBuilder >> checkMCPackage: aMCPackage [

	self glorpSession inTransactionDo: [ self privCheckMCPackage: aMCPackage ]
]

{ #category : #'accessing-queries' }
SPGlorpDiffBuilder >> deleteDiffsQuery [

	| sql |
	
	sql := 'DELETE FROM mc_class_diffs WHERE to_package_id = $1'.
	^ p3queries at: sql ifAbsentPut: [ p3queries createQuery: sql ]
]

{ #category : #accessing }
SPGlorpDiffBuilder >> glorpSession [
	^ glorpSession
]

{ #category : #accessing }
SPGlorpDiffBuilder >> glorpSession: aSession [

	| p3client |
	
	glorpSession := aSession.
	
	p3client := aSession accessor databaseDriver connection.
	p3queries := SPP3Queries new initWithClient: p3client.
]

{ #category : #enumerating }
SPGlorpDiffBuilder >> inUnitOfWorkDo: aBlock [

	glorpSession beginUnitOfWork.
	[ 
		aBlock value.
		glorpSession commitUnitOfWork
	] ensure: [ 
		glorpSession hasUnitOfWork
			ifTrue: [ glorpSession rollbackUnitOfWork ] ]

]

{ #category : #'accessing-queries' }
SPGlorpDiffBuilder >> insertDiffsQuery [

	| sql |
	
	sql := 'INSERT INTO mc_class_diffs (from_package_id, to_package_id, old_class_id, new_class_id) VALUES ($1,$2,$3,$4)'.
	^ p3queries at: sql ifAbsentPut: [ p3queries createQuery: sql ]
]

{ #category : #actions }
SPGlorpDiffBuilder >> privCheckMCPackage: aMCPackage [

	| records |
	
	self deleteDiffsQuery execute: (Array with: aMCPackage id).
	
	records := aMCPackage createClassDiffRecords.
	self insertDiffsQuery executeBatch: (
		records collect: [ :each |
			Array 
				with: each fromPackageId
				with: each toPackageId
				with: each oldClassId
				with: each newClassId ]).
]
