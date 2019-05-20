Class {
	#name : #SpiderLoader,
	#superclass : #Object,
	#category : #'Spider-Setup'
}

{ #category : #database }
SpiderLoader >> clearPostgres: anUrl [
	"self new clearPostgres: 'psql://sptest:sptest@theraver5:5432/postgres'"

	| client tablesResult seqResult |
	
	client := P3Client url: anUrl.
	[  
		tablesResult := client query: 'select tablename from pg_tables where tableowner = current_user'.
		
		tablesResult data do: [ :each |
			client query: ('DROP TABLE {1} CASCADE' format: { each first }) ].
			
		seqResult := client query: 'select sequencename from pg_sequences where sequenceowner = current_user'.
		seqResult data do: [ :each |
			client query: ('DROP SEQUENCE {1}' format: { each first }) ].
	] ensure: [ client close ]
]

{ #category : #database }
SpiderLoader >> createPostgresSchema: aP3Client [
	"self new createPostgresSchema: (P3Client url: 'psql://spmain:spmain@theraver5:5432/postgres'"
	
	aP3Client execute: SPSessionPostgresRepository dbSchema.
	aP3Client execute: SPMethodPostgresRepository dbSchema.
	aP3Client execute: SPClassPostgresRepository dbSchema.
	aP3Client execute: SPPackagePostgresRepository dbSchema.
	aP3Client execute: SPMonticelloPackagePostgresRepository dbSchema.

]

{ #category : #resources }
SpiderLoader >> gofer [

	^ Gofer new
		url: 'https://mc.cloudctrl.com/etc' username: 'jvds' password: 'oranje00';
		yourself
]

{ #category : #loading }
SpiderLoader >> load [
	"self new load"

	self loadP3.
	self loadSQLite.
	self loadCompatibility.
	
	self loadBase.
	self loadModels.
	self loadModelTests.
	
	self loadImport.

]

{ #category : #loading }
SpiderLoader >> loadBase [


]

{ #category : #loading }
SpiderLoader >> loadCompatibility [

	self gofer
		package: 'Spider-Compatibility';
		load
]

{ #category : #loading }
SpiderLoader >> loadImport [

	self gofer
		package: 'Spider-Import';
		load
]

{ #category : #loading }
SpiderLoader >> loadModelTests [

	self gofer
		package: 'Spider-Core-Model-Tests';
		package: 'Spider-Method-Model-Tests';
		package: 'Spider-Class-Model-Tests';
		package: 'Spider-Package-Model-Tests';
		package: 'Spider-Monticello-Model-Tests';
		package: 'Spider-Git-Model-Tests';
		load

]

{ #category : #loading }
SpiderLoader >> loadModels [

	self gofer
		package: 'Spider-Core-Model';
		package: 'Spider-Method-Model';
		package: 'Spider-Class-Model';
		package: 'Spider-Package-Model';
		package: 'Spider-Monticello-Model';
		package: 'Spider-Git-Model';
		load

]

{ #category : #loading }
SpiderLoader >> loadP3 [

	Metacello new
		baseline: 'P3';
  		repository: 'github://svenvc/P3';
		load.
]

{ #category : #loading }
SpiderLoader >> loadSQLite [
	"self new loadSQLite"

	self gofer
		package: 'SQLite-Core';
		package: 'SQLite-Tests';
		package: 'SQLite-Mapper';
		load
]

{ #category : #loading }
SpiderLoader >> loadWebUIDev [
	"self new loadWebUIDev"

	self loadCompatibility.
	
	self loadBase.
	self loadModels.
	self loadModelTests.

]

{ #category : #database }
SpiderLoader >> setupPostgres: anUrl [
	"self new setupPostgres: 'psql://spmain:spmain@theraver5:5432/postgres'"

	| client tablesResult seqResult |
	
	client := P3Client url: anUrl.
	[  
		self createPostgresSchema: client.
		tablesResult := client query: 'select tablename from pg_tables where tableowner = current_user'.
		seqResult := client query: 'select sequencename from pg_sequences where sequenceowner = current_user'.
		
		tablesResult data do: [ :each |
			client query: ('GRANT SELECT ON TABLE {1} TO PUBLIC' format: { each first }).
			client query: ('GRANT SELECT,INSERT ON TABLE {1} TO spimporter' format: { each first }) ].

		client query: 'GRANT UPDATE(package_id) ON TABLE mc_packages TO spimporter'.
		client query: 'GRANT UPDATE(root_id) ON TABLE mc_packages TO spimporter'.
			
		seqResult data do: [ :each |
			client query: ('GRANT USAGE ON SEQUENCE {1} TO spimporter' format: { each first }) ].
				
	] ensure: [ client close ]

]

{ #category : #database }
SpiderLoader >> setupPostgresTest: anUrl [
	"self new setupPostgresTest: 'psql://sptest:sptest@theraver5:5432/postgres'"

	SPiderContextTestResource bePostgres.
	SPiderContextTestResource postgresTestDatabaseUrl: anUrl
]
