Class {
	#name : #SPiderPostgreSQLContext,
	#superclass : #SPiderContext,
	#instVars : [
		'client'
	],
	#category : #'Spider-Model-RDB'
}

{ #category : #'instance creation' }
SPiderPostgreSQLContext class >> openOn: aClient [

	^ self new
			setClient: aClient;
			yourself
]

{ #category : #'instance creation' }
SPiderPostgreSQLContext class >> openOnUrl: anUrl [

	| url connectString login accessor glorpSession |

	PharoDatabaseAccessor DefaultDriver: P3DatabaseDriver.

	url := anUrl asZnUrl.	
	connectString := url host, ':', (url port ifNil: [ 5432 ]) asString, '_', url path.
	
	login := 	Login new
		database: PostgreSQLPlatform new;
		username: url username;
		password: url password;
		connectString: connectString;
		encodingStrategy: #utf8;
		yourself.
		
	accessor := DatabaseAccessor forLogin: login.
	accessor logging: true.
	accessor login.

	glorpSession := SpiderDescriptorSystem sessionForAccessor: accessor.
	
	^ self new
			setGlorpSession: glorpSession;
			setClient: accessor databaseDriver connection;
			yourself
]

{ #category : #actions }
SPiderPostgreSQLContext >> beginTransaction [ 

	super beginTransaction.
	client execute: 'BEGIN TRANSACTION'
]

{ #category : #accessing }
SPiderPostgreSQLContext >> client [ 
	^ client
]

{ #category : #'initialization-release' }
SPiderPostgreSQLContext >> close [

	glorpSession notNil
		ifTrue: [ 
			glorpSession accessor isLoggedIn
				ifTrue: [ glorpSession accessor logout ].
			glorpSession release.
			glorpSession := nil.
			client := nil ].

	client notNil
		ifTrue: [ 
			client close.
			client := nil ].
		
	super close
]

{ #category : #actions }
SPiderPostgreSQLContext >> commitTransaction [ 

	super commitTransaction.
	client execute: 'COMMIT'
]

{ #category : #running }
SPiderPostgreSQLContext >> createClassRepo [

	^ SPClassPostgresRepository new
			setContext: self;
			setClient: client;
			yourself
]

{ #category : #running }
SPiderPostgreSQLContext >> createGitRepo [

	^ SPGitPostgresRepository new
			setContext: self;
			setClient: client;
			yourself
]

{ #category : #running }
SPiderPostgreSQLContext >> createMCPackageRepo [

	^ SPMonticelloPackagePostgresRepository new
			setContext: self;
			setClient: client;
			yourself
]

{ #category : #running }
SPiderPostgreSQLContext >> createMethodRepo [

	^ SPMethodPostgresRepository new
			setContext: self;
			setClient: client;
			yourself
]

{ #category : #running }
SPiderPostgreSQLContext >> createPackageRepo [

	^ SPPackagePostgresRepository new
			setContext: self;
			setClient: client;
			yourself
]

{ #category : #'initialization-release' }
SPiderPostgreSQLContext >> createSession [

	^ self sessionRepo newSession

	
]

{ #category : #running }
SPiderPostgreSQLContext >> createSessionRepo [

	^ SPSessionPostgresRepository new
			setContext: self;
			setClient: client;
			yourself
]

{ #category : #accessing }
SPiderPostgreSQLContext >> logging [

	^ self glorpSession accessor logging
]

{ #category : #accessing }
SPiderPostgreSQLContext >> logging: aBoolean [

	self glorpSession accessor logging: aBoolean
]

{ #category : #running }
SPiderPostgreSQLContext >> newTransaction: aMessage [

	^ self sessionRepo newTransaction: aMessage with: self session
]

{ #category : #actions }
SPiderPostgreSQLContext >> rollbackTransaction [ 

	client execute: 'ROLLBACK'.
	super rollbackTransaction.
]

{ #category : #'initialization-release' }
SPiderPostgreSQLContext >> setClient: aP3Client [

	client := aP3Client.

]

{ #category : #'initialization-release' }
SPiderPostgreSQLContext >> setGlorpSession: aGlorpSession [

	glorpSession := aGlorpSession

]
