Class {
	#name : #SPClassPostgresRepository,
	#superclass : #SPClassRDBRepository,
	#instVars : [
		'client',
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #resources }
SPClassPostgresRepository class >> dbSchema [

	^ '
CREATE TABLE IF NOT EXISTS classes (
	id SERIAL PRIMARY KEY,
	txid INT NOT NULL,
	type INT NOT NULL,
	name VARCHAR NOT NULL,
	hash BYTEA NOT NULL UNIQUE,
	class_type VARCHAR,
	superclassname VARCHAR,
	inst_trait VARCHAR,
	class_trait VARCHAR,
	comment VARCHAR
);
CREATE INDEX IF NOT EXISTS class_name_idx ON classes(name);
CREATE INDEX IF NOT EXISTS class_superclass_idx ON classes(superclassname);
CREATE INDEX IF NOT EXISTS class_hash_idx ON classes(hash);

CREATE TABLE IF NOT EXISTS class_var_refs (
	class_id INTEGER NOT NULL REFERENCES classes (id) ON DELETE CASCADE,
	type INTEGER NOT NULL,
	variable VARCHAR NOT NULL,
	expression TEXT,
	PRIMARY KEY (class_id, type, variable)
);
CREATE INDEX IF NOT EXISTS class_var_refs_idx ON class_var_refs(variable);

CREATE TABLE IF NOT EXISTS class_met_refs (
	class_id INTEGER NOT NULL REFERENCES classes (id) ON DELETE CASCADE,
	type INTEGER NOT NULL,
	method_id INTEGER NOT NULL REFERENCES methods (id),
	category TEXT,
	PRIMARY KEY (class_id, type, method_id)
);
CREATE INDEX IF NOT EXISTS class_met_refs_idx ON class_met_refs(method_id);
'
]

{ #category : #initialization }
SPClassPostgresRepository >> checkSchema [

	| result |

	result := client execute: self class dbSchema.

]

{ #category : #'accessing - queries' }
SPClassPostgresRepository >> insertClassQuery [

	| sql |
	
	sql := 'INSERT INTO classes (txid, type, name, hash, class_type, superclassname, inst_trait, class_trait, comment) 
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING (id)'.
	
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPClassPostgresRepository >> insertMRelQuery [

	| sql |
	
	sql := 'INSERT INTO class_met_refs (class_id, type, method_id, category) VALUES ($1,$2,$3,$4)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPClassPostgresRepository >> insertVarRelQuery [

	| sql |
	
	sql := 'INSERT INTO class_var_refs (class_id, type, variable, expression) VALUES ($1,$2,$3,$4)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #initialization }
SPClassPostgresRepository >> setClient: p3Client [

	client := p3Client.
	queries := SPP3Queries new initWithClient: client
]

{ #category : #'accessing - queries' }
SPClassPostgresRepository >> updateHashQuery [

	| sql |
	
	sql := 'UPDATE classes SET hash = $2 WHERE id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]
