Extension { #name : #SPiderContextTestResource }

{ #category : #'*Spider-Model-RDB' }
SPiderContextTestResource >> createPostgresContext [

	^ SPiderPostgreSQLContext openOnUrl: self class postgresTestDatabaseUrl
]
