Extension { #name : #SPiderContextTestResource }

{ #category : #'*Spider-Model-RDB' }
SPiderContextTestResource >> createPostgresContext [

	| ctx |

	ctx := SPiderPostgreSQLContext openOnUrl: self class postgresTestDatabaseUrl.
	
	"disable looging to transcript"
	ctx glorpSession accessor logging: false.
	
	^ ctx
]
