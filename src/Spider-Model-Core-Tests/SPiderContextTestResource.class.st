Class {
	#name : #SPiderContextTestResource,
	#superclass : #TestResource,
	#instVars : [
		'context'
	],
	#classVars : [
		'ContextCreateMethod',
		'PostgresTestDatabaseUrl'
	],
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #'as yet unclassified' }
SPiderContextTestResource class >> beImage [

	ContextCreateMethod := #createImageContext
]

{ #category : #'as yet unclassified' }
SPiderContextTestResource class >> bePostgres [

	ContextCreateMethod := #createPostgresContext
]

{ #category : #'as yet unclassified' }
SPiderContextTestResource class >> beSQLite [

	ContextCreateMethod := #createSQLiteContext
]

{ #category : #accessing }
SPiderContextTestResource class >> postgresTestDatabaseUrl [

	^ PostgresTestDatabaseUrl ifNil: [ 'psql://sptest:sptest@theraver5:5432/postgres' ]

	
]

{ #category : #accessing }
SPiderContextTestResource class >> postgresTestDatabaseUrl: anUrl [

	PostgresTestDatabaseUrl := anUrl

	
]

{ #category : #initialization }
SPiderContextTestResource >> clearPostgresTables: p3Client [
	"Clear all tables of the current user"

	| tablesResult truncateQuery |
	
	tablesResult := p3Client query: 'select tablename from pg_tables where tableowner = current_user'.
	tablesResult data isEmpty
		ifTrue: [ ^ self ].

	truncateQuery := String streamContents: [ :s |
		s nextPutAll: 'TRUNCATE '.
		tablesResult data 
			do: [ :each | s nextPutAll: each first ]
			separatedBy: [ s nextPut: $, ].
		s nextPutAll: ' CASCADE' ].
	p3Client execute: truncateQuery.
	p3Client execute: 'COMMIT'.
]

{ #category : #accessing }
SPiderContextTestResource >> context [
	^ context
]

{ #category : #accessing }
SPiderContextTestResource >> contextCreateMethod [

	^ ContextCreateMethod
]

{ #category : #initialization }
SPiderContextTestResource >> createImageContext [

	^ SPiderImageContext new
]

{ #category : #initialization }
SPiderContextTestResource >> createPostgresContext [

	^ SPiderPostgreSQLContext openOnUrl: self class postgresTestDatabaseUrl
]

{ #category : #initialization }
SPiderContextTestResource >> createSQLiteContext [

	^ SPiderSQLiteContext openInMemory
]

{ #category : #testing }
SPiderContextTestResource >> isAvailable [ 

	^ context notNil
]

{ #category : #running }
SPiderContextTestResource >> resetForClasses [

	self resetForMethods.
	self context classRepo checkSchema

	
]

{ #category : #running }
SPiderContextTestResource >> resetForMCPackages [

	self resetForPackages.
	self context mcPackageRepo checkSchema

	
]

{ #category : #running }
SPiderContextTestResource >> resetForMethods [

	(self context isKindOf: SPiderPostgreSQLContext)
		ifTrue: [ self clearPostgresTables: self context client ].

	self context sessionRepo checkSchema.
	self context methodRepo checkSchema.

	
]

{ #category : #running }
SPiderContextTestResource >> resetForPackages [

	self resetForClasses.
	self context packageRepo checkSchema

	
]

{ #category : #running }
SPiderContextTestResource >> setUp [

	super setUp.
	self setUpContext
]

{ #category : #running }
SPiderContextTestResource >> setUpContext [

	context := self contextCreateMethod notNil
		ifTrue: [ self perform: self contextCreateMethod ]
		ifFalse: [ self createImageContext ]
]

{ #category : #running }
SPiderContextTestResource >> tearDown [ 

	context notNil 
		ifTrue: [ 
			[ context close ] ensure: [ context := nil ] ].
	super tearDown
]
