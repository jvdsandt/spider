Class {
	#name : #SPMethodPostgresRepository,
	#superclass : #SPMethodRDBRepository,
	#instVars : [
		'client'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #resources }
SPMethodPostgresRepository class >> dbSchema [

	^'
CREATE TABLE IF NOT EXISTS methods (
	id SERIAL PRIMARY KEY,
	txid INT NOT NULL,
	selector VARCHAR NOT NULL,
	hash BYTEA NOT NULL UNIQUE,
	source TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS methods_selector_idx ON methods (selector);
CREATE INDEX IF NOT EXISTS methods_hash_idx ON methods (hash);

CREATE TABLE IF NOT EXISTS method_var_refs (
	method_id INT NOT NULL REFERENCES methods (id) ON DELETE CASCADE,
	variable VARCHAR NOT NULL,
	flags INT NOT NULL,
	PRIMARY KEY (method_id, variable)
);
CREATE INDEX IF NOT EXISTS method_var_refs_idx ON method_var_refs (variable);

CREATE TABLE IF NOT EXISTS method_sel_refs (
	method_id INT NOT NULL REFERENCES methods (id) ON DELETE CASCADE,
	selector VARCHAR NOT NULL,
	flags INT NOT NULL,
	PRIMARY KEY (method_id, selector)
);
CREATE INDEX IF NOT EXISTS method_sel_refs_idx ON method_sel_refs (selector);'
]

{ #category : #queries }
SPMethodPostgresRepository >> allSelectors [

	| q1 q2 query |
	
	q1 := (Query read: SPGlorpMethodToSelectorRef)
		retrieve: [ :e | e selector ];
		yourself.
		
	q2 := (Query read: SPGlorpMethod)
		retrieve: [ :e | e selector ];
		yourself.
		
	query := (q1 unionAll: q2)
		orderBy: [ :e | e selector ];
		yourself.

	^ self glorpSession execute: query
]

{ #category : #queries }
SPMethodPostgresRepository >> allVariables [

	| query |
	
	query := (Query read: SPGlorpMethodToVariableRef)
		retrieve: [ :e | e variable distinct ];
		orderBy: [ :e | e variable ];
		yourself.
		
	^ self glorpSession execute: query
]

{ #category : #initialization }
SPMethodPostgresRepository >> checkSchema [

	| result |

	result := client execute: self class dbSchema.

]

{ #category : #'accessing - queries' }
SPMethodPostgresRepository >> insertMethodQuery [

	| sql |
	
	sql := 'INSERT INTO methods (txid, selector, hash, source) VALUES ($1,$2,$3,$4) RETURNING (id)'.
	^queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPMethodPostgresRepository >> insertMethodSelRefQuery [

	| sql |
	
	sql := 'INSERT INTO method_sel_refs (method_id, selector, flags) VALUES ($1,$2,$3)'.
	^queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPMethodPostgresRepository >> insertMethodVarRefQuery [

	| sql |
	
	sql := 'INSERT INTO method_var_refs (method_id, variable, flags) VALUES ($1,$2,$3)'.
	^queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #initialization }
SPMethodPostgresRepository >> setClient: aP3Client [

	client := aP3Client.
	queries := SPP3Queries new initWithClient: client
]

{ #category : #storing }
SPMethodPostgresRepository >> storeMethod: aMethod [

	| method methodId |
	
	method := self selectMethodByHash: aMethod sourceHash ifAbsent: [ nil ].
	method notNil
		ifTrue: [ ^ method id ].
		
	methodId := self insertMethodQuery getOne: (Array 
			with: self transactionId 
			with: aMethod selector
			with: aMethod sourceHash 
			with: aMethod source).
			
	self insertMethodSelRefQuery executeBatch: (aMethod selectorRefs collect: [ :each |
		Array with: methodId with: each selector with: each flags ]).
	
	self insertMethodVarRefQuery executeBatch: (aMethod variableRefs collect: [ :each |
		Array with: methodId with: each variable with: each flags ]).
			
	^ methodId
]
