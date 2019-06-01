Class {
	#name : #SPClassPostgresRepository,
	#superclass : #SPClassRDBRepository,
	#instVars : [
		'client'
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

{ #category : #initialization }
SPClassPostgresRepository >> setClient: p3Client [

	client := p3Client.
	queries := SPP3Queries new initWithClient: client
]
