Class {
	#name : #SPMonticelloPackagePostgresRepository,
	#superclass : #SPMonticelloPackageRDBRepository,
	#instVars : [
		'client'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #resources }
SPMonticelloPackagePostgresRepository class >> dbSchema [

	^'
CREATE TABLE IF NOT EXISTS mc_packages (
	id SERIAL PRIMARY KEY,
	txid INTEGER NOT NULL,
	root_id INTEGER REFERENCES mc_packages(id),
	name TEXT NOT NULL,
	mc_id BYTEA NOT NULL,
	datetime TIMESTAMP NOT NULL,
	author TEXT NOT NULL,
	version INTEGER NOT NULL,
	message TEXT,
	branch TEXT,
	package_id INTEGER REFERENCES packages(id)
);
CREATE UNIQUE INDEX IF NOT EXISTS mc_packages_name_idx ON mc_packages(name, mc_id);
CREATE INDEX IF NOT EXISTS mc_packages_root_idx ON mc_packages(root_id);
CREATE INDEX IF NOT EXISTS mc_packages_author_idx ON mc_packages(author);
CREATE INDEX IF NOT EXISTS mc_packages_dt_idx ON mc_packages(datetime);

CREATE TABLE IF NOT EXISTS mc_package_ancestors (
	mc_package_id INTEGER NOT NULL REFERENCES mc_packages(id),
	mc_ancestor_id INTEGER NOT NULL REFERENCES mc_packages(id),
	PRIMARY KEY (mc_package_id, mc_ancestor_id)
);
CREATE INDEX IF NOT EXISTS mc_packages_ancestor_idx ON mc_package_ancestors(mc_ancestor_id);

CREATE TABLE IF NOT EXISTS mc_repos (
	id SERIAL PRIMARY KEY,
	txid INTEGER NOT NULL,
	repo_url TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS mc_repo_pack_refs (
	mc_repo_id INTEGER NOT NULL REFERENCES mc_repos(id),
	mc_package_id INTEGER NOT NULL REFERENCES mc_packages(id),
	txid INTEGER NOT NULL,
	filename TEXT NOT NULL,
	PRIMARY KEY (mc_repo_id, filename)
);
CREATE INDEX IF NOT EXISTS mc_repo_pack_refs_pack_idx ON mc_repo_pack_refs(mc_package_id);
'
]

{ #category : #resources }
SPMonticelloPackagePostgresRepository class >> dbViewDefs [

	^'
CREATE VIEW v_mc_class_versions AS
	SELECT
		mpr.id as mc_package_root_id,
		mp.id as mc_package_id,
		p.id as package_id,
		p.name as package_name,
		mp.datetime as mc_package_datetime,
		mp.author as author,
		mp.version as version,
		mp.message as message,
		mp.branch as branch,
		pcr.category as class_category,
		c.id as class_id,
		cname.variable as class_name
	FROM
		classes c
		JOIN variables cname ON c.name_id = cname.id
		JOIN package_cls_refs pcr ON c.id = pcr.class_id
		JOIN packages p ON pcr.package_id = p.id
		JOIN mc_packages mp ON p.id = mp.package_id
		JOIN mc_packages mpr ON mp.root_id = mpr.id;'
]

{ #category : #initialization }
SPMonticelloPackagePostgresRepository >> checkSchema [

	| result |

	result := client execute: self class dbSchema.

]

{ #category : #utilities }
SPMonticelloPackagePostgresRepository >> fixRootIds [
	"Set the root_id column to its correct value using the ancestor relations."

	| setRootsQ selectQ result |
	
	"Set root_id of MC packages without ancestors"
	setRootsQ := 'UPDATE mc_packages SET root_id = id 
	WHERE id NOT IN (SELECT mc_package_id FROM mc_package_ancestors)'.
 	client execute: setRootsQ.
	
	"Select all MC packages without a root_id but with an ancestor with a root_id"
	selectQ := 'SELECT mp.root_id, mc_package_id
FROM 
	mc_package_ancestors 
	JOIN mc_packages mp ON mc_ancestor_id = mp.id
WHERE 
	mc_package_id in (select id from mc_packages where root_id IS NULL) AND
	mc_ancestor_id in (select id from mc_packages where root_id is not null)'.
	
	[  
		result := client query: selectQ.
		result data do: [ :eachRow |
			self updateMCPackageRootdIdQuery execute: eachRow ].
		self logInfo: 'Updated root_id of ', result data size asString, ' mc_packages'.
		result data notEmpty ] whileTrue
]

{ #category : #initialization }
SPMonticelloPackagePostgresRepository >> setClient: p3Client [

	client := p3Client.
	queries := SPP3Queries new initWithClient: client
]
