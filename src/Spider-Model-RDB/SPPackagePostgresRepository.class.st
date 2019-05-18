Class {
	#name : #SPPackagePostgresRepository,
	#superclass : #SPPackageRDBRepository,
	#instVars : [
		'client',
		'queries'
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

{ #category : #'accessing - queries' }
SPPackagePostgresRepository >> insertPackageClassRelQuery [

	| sql |
	
	sql := 'INSERT INTO package_cls_refs (package_id, class_id, category) VALUES ($1,$2,$3)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPPackagePostgresRepository >> insertPackageQuery [

	| sql |
	
	sql := 'INSERT INTO packages (txid, name, hash, comment) VALUES ($1,$2,$3,$4) RETURNING (id)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #initialization }
SPPackagePostgresRepository >> setClient: p3Client [

	client := p3Client.
	queries := SPP3Queries new initWithClient: client
]

{ #category : #'accessing - queries' }
SPPackagePostgresRepository >> updateHashQuery [

	| sql |
	
	sql := 'UPDATE packages SET hash = $2 WHERE id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]
