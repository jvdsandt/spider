Class {
	#name : #SPPackagePostgresRepository,
	#superclass : #SPPackageRDBRepository,
	#instVars : [
		'client'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #resources }
SPPackagePostgresRepository class >> dbSchema [

	^ '
CREATE TABLE IF NOT EXISTS packages (
	id SERIAL PRIMARY KEY,
	txid INTEGER NOT NULL,
	name TEXT NOT NULL,
	hash BYTEA NOT NULL UNIQUE,
	comment TEXT
);
CREATE INDEX IF NOT EXISTS package_name_idx ON packages(name);

CREATE TABLE IF NOT EXISTS package_cls_refs (
	package_id INTEGER NOT NULL REFERENCES packages(id) ON DELETE CASCADE,
	class_id INTEGER NOT NULL REFERENCES classes(id),
	category TEXT,
	PRIMARY KEY (package_id, class_id)
);
CREATE INDEX IF NOT EXISTS package_cls_refs_idx ON package_cls_refs(class_id);
'
]

{ #category : #initialization }
SPPackagePostgresRepository >> checkSchema [

	| result |

	result := client execute: self class dbSchema.

]

{ #category : #initialization }
SPPackagePostgresRepository >> setClient: p3Client [

	client := p3Client.
	queries := SPP3Queries new initWithClient: client
]
