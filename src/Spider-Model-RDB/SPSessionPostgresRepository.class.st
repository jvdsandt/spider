Class {
	#name : #SPSessionPostgresRepository,
	#superclass : #SPSessionRDBRepository,
	#instVars : [
		'client',
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #resources }
SPSessionPostgresRepository class >> dbSchema [

	^ '
CREATE TABLE IF NOT EXISTS sp_sessions (
	id SERIAL PRIMARY KEY,
	started_at TIMESTAMP NOT NULL,
	image_version TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS sp_session_idx ON sp_sessions(started_at);

CREATE TABLE IF NOT EXISTS sp_transactions (
	id SERIAL PRIMARY KEY,
	sp_session_id INTEGER NOT NULL REFERENCES sp_sessions(id),
	started_at TIMESTAMP NOT NULL,
	message TEXT
);
CREATE INDEX IF NOT EXISTS sp_transaction_session_idx ON sp_transactions(sp_Session_id);
CREATE INDEX IF NOT EXISTS sp_transaction_idx ON sp_transactions(started_at);
'
]

{ #category : #initialization }
SPSessionPostgresRepository >> checkSchema [

	| result |

	result := client execute: self class dbSchema.

]

{ #category : #'accessing - queries' }
SPSessionPostgresRepository >> insertSessionQuery [

	| sql |
	
	sql := 'INSERT INTO sp_sessions (started_at, image_version) VALUES ($1,$2) RETURNING (id)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPSessionPostgresRepository >> insertTransactionQuery [

	| sql |
	
	sql := 'INSERT INTO sp_transactions (sp_session_id, started_at, message) 
VALUES ($1,$2,$3) RETURNING (id)'.
	
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]

]

{ #category : #queries }
SPSessionPostgresRepository >> latestTransactions: aCount [

	^ self latestTransactionsBefore: DateAndTime now + 2 years max: aCount
]

{ #category : #'accessing - queries' }
SPSessionPostgresRepository >> selectLatestTransactionsQuery [

	| sql |
	
	sql := 'SELECT tx.id, tx.started_at, tx.message, s.id, s.started_at, s.image_version
	FROM 
		sp_transactions tx
		JOIN sp_sessions s ON s.id = tx.sp_session_id 
	WHERE
		tx.started_at < $1
	ORDER BY tx.started_at DESC
	LIMIT $2'.
	
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #initialization }
SPSessionPostgresRepository >> setClient: p3Client [

	client := p3Client.
	queries := SPP3Queries new initWithClient: client
]
