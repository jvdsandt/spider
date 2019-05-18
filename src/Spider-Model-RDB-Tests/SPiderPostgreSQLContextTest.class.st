Class {
	#name : #SPiderPostgreSQLContextTest,
	#superclass : #TestCase,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #running }
SPiderPostgreSQLContextTest >> p3Client [

	^ context client
]

{ #category : #running }
SPiderPostgreSQLContextTest >> setUp [

	| client |

	super setUp.
	
	client := P3Client url: SPiderContextTestResource postgresTestDatabaseUrl.
	context := SPiderPostgreSQLContext openOn: client.

]

{ #category : #running }
SPiderPostgreSQLContextTest >> tearDown [

	context notNil
		ifTrue: [ context close. context := nil ].
	super tearDown
]

{ #category : #running }
SPiderPostgreSQLContextTest >> testTransactions [

	| client |
	
	client := context client.
	
	client execute: 'DROP TABLE IF EXISTS table_tx_test'.
	client execute: 'CREATE TABLE table_tx_test (id INTEGER, name TEXT, enabled BOOLEAN)'.
	
	context beginTransaction.
	client execute: 'INSERT INTO table_tx_test (id, name,enabled) VALUES (100, ''Test-100'', true)'.
	context commitTransaction.
	self assert: (client query: 'SELECT COUNT(*) FROM table_tx_test') firstRecord first equals: 1.
	
	context beginTransaction.
	client execute: 'INSERT INTO table_tx_test (id, name,enabled) VALUES (200, ''Test-200'', true)'.
	context rollbackTransaction.
	self assert: (client query: 'SELECT COUNT(*) FROM table_tx_test') firstRecord first equals: 1.

	context beginTransaction.
	client execute: 'DELETE FROM table_tx_test'.
	context rollbackTransaction.
	self assert: (client query: 'SELECT COUNT(*) FROM table_tx_test') firstRecord first equals: 1.

	context beginTransaction.
	client execute: 'DELETE FROM table_tx_test'.
	context commitTransaction.
	self assert: (client query: 'SELECT COUNT(*) FROM table_tx_test') firstRecord first equals: 0.

]
