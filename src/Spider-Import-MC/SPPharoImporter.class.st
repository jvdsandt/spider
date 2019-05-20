Class {
	#name : #SPPharoImporter,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#classVars : [
		'DatabaseUrl'
	],
	#category : #'Spider-Import-MC-Spider-Import-MC'
}

{ #category : #'as yet unclassified' }
SPPharoImporter class >> databaseUrl [

	^ DatabaseUrl ifNil: [  ]
]

{ #category : #'as yet unclassified' }
SPPharoImporter class >> databaseUrl: anUrl [

	DatabaseUrl := anUrl
]

{ #category : #actions }
SPPharoImporter class >> importAllUsing: spiderContext [

	| instance |
	
	instance := self newWithContext: spiderContext.
	
	RPackage organizer packagesDo: [ :each |
		spiderContext
			doTransaction: 'Importing'
			with: [ instance importRPackage: each ] ].
		
	"self importAllUsing: (SPiderSQLiteContext openOnFile: 'd:\tmp\pharo.db')"

	"	| context |
		context := SPiderImageContext new.
		self importAllUsing: context.
		context
	"

	"	| context |
		context := SPiderPostgreSQLContext openOnUrl: 'psql://sptest:sptest@localhost:5432/postgres'.
		self importAllUsing: context.
		context
	"


]

{ #category : #'instance creation' }
SPPharoImporter class >> newWithContext: spiderContext [

	^ self new initWithContext: spiderContext
]

{ #category : #actions }
SPPharoImporter >> importAll [

	RPackage organizer packagesDo: [ :each |
		self importRPackage: each ]
]

{ #category : #actions }
SPPharoImporter >> importRPackage: rPackage [

	| package |
	
	package := self packageRepo newBuilder
		setRPackage: rPackage;
		build.
		
	self packageRepo storePackage: package
]

{ #category : #initialization }
SPPharoImporter >> initWithContext: spiderContext [

	context := spiderContext
]

{ #category : #accessing }
SPPharoImporter >> packageRepo [
	^ context packageRepo
]
