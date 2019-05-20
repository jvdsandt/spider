Class {
	#name : #SPMonticelloImporter,
	#superclass : #Object,
	#instVars : [
		'context',
		'mcPackageRepo'
	],
	#classVars : [
		'DatabaseUrl'
	],
	#category : #'Spider-Import-MC-Spider-Import-MC'
}

{ #category : #utilities }
SPMonticelloImporter class >> createContext [

	^ SPiderPostgreSQLContext openOnUrl: self databaseUrl
]

{ #category : #accessing }
SPMonticelloImporter class >> databaseUrl [ 

	^ DatabaseUrl ifNil: [ 'psql://spimporter:spimporter@theraver5:5432/postgres' ]
]

{ #category : #accessing }
SPMonticelloImporter class >> databaseUrl: anUrl [

	DatabaseUrl := anUrl
]

{ #category : #utilities }
SPMonticelloImporter class >> importMCRepo: anUrl [

	| context instance |
	
	context := self createContext.
	context logging: false.
	[ 
		instance := self newWithContext: context.
		instance importMCRepo: anUrl.
	] ensure: [ context close ]


]

{ #category : #utilities }
SPMonticelloImporter class >> importMagritte1 [
	"self importMagritte1"

	| context instance |
	
	context := self createContext.
	[  
		instance := self newWithContext: context.
		instance importMagritte1
	] ensure: [ context close ]
]

{ #category : #utilities }
SPMonticelloImporter class >> importMagritte2 [
	"self importMagritte2"

	| context instance |
	
	context := self createContext.
	[  
		instance := self newWithContext: context.
		instance importMagritte2
	] ensure: [ context close ]
]

{ #category : #utilities }
SPMonticelloImporter class >> importMagritte3 [
	"self importMagritte3"

	| context instance |
	
	context := self createContext.
	[  
		instance := self newWithContext: context.
		instance importMagritte3
	] ensure: [ context close ]
]

{ #category : #utilities }
SPMonticelloImporter class >> importRB [
	"self importRB"

	self importMCRepo: 'http://www.squeaksource.com/rb'


]

{ #category : #utilities }
SPMonticelloImporter class >> importSeaside [

	self importMCRepo: 'http://www.squeaksource.com/Seaside'

]

{ #category : #utilities }
SPMonticelloImporter class >> importSeaside30 [

	self importMCRepo: 'http://www.smalltalkhub.com/mc/Seaside/Seaside30/main'


]

{ #category : #utilities }
SPMonticelloImporter class >> importSeaside31 [

	self importMCRepo: 'http://www.smalltalkhub.com/mc/Seaside/Seaside31/main'


]

{ #category : #utilities }
SPMonticelloImporter class >> importSeaside32 [

	self importMCRepo: 'http://www.smalltalkhub.com/mc/Seaside/Seaside32/main'


]

{ #category : #utilities }
SPMonticelloImporter class >> importXtreams [
	"self importXtreams"

	self importMCRepo: 'http://www.squeaksource.com/Xtreams'


]

{ #category : #'instance creation' }
SPMonticelloImporter class >> newWithContext: aSPiderContext [

	^ self new initWithContext: aSPiderContext
]

{ #category : #actions }
SPMonticelloImporter >> importGoferReference: aResolvedReference [

	self importMCVersion: aResolvedReference version
]

{ #category : #actions }
SPMonticelloImporter >> importGoferReference: aResolvedReference fromRepo: aRepoUrl [

	| version |
	
	version := [ aResolvedReference version ] on: Error do: [ :ex |
		self logInfo: 'Failed to get version: ', aResolvedReference name, ' error: ', ex messageText.
		^ self ].
	
	[ 
		self importMCVersion: version
				name: aResolvedReference name
				fromRepo: aRepoUrl
	] on: Error do: [ :ex |
		self logInfo: 'Failed to import version: ', aResolvedReference name, ' error: ', ex messageText ]
]

{ #category : #actions }
SPMonticelloImporter >> importMCRepo: repoUrl [

	| refs |
	
	refs := Gofer new
		disablePackageCache ;
		url: repoUrl;
		allResolved.

	refs do: [ :eachRef |
		(self mcPackageRepo hasFile: eachRef name fromRepo: repoUrl)
			ifTrue: [ 
				self logInfo: 'Package ', eachRef name, ' already imported' ]
			ifFalse: [ 
				self importGoferReference: eachRef fromRepo: repoUrl ] ]
]

{ #category : #actions }
SPMonticelloImporter >> importMCVersion: mcVersion [

	| mcPackage startTS duration |

	mcVersion snapshot definitions isEmpty
		ifTrue: [ ^ self ].
	
	startTS := Time millisecondClockValue.	
	context
		doTransaction: 'Import Monticello package ', mcVersion info name
		with: [ 
			mcPackage := self mcPackageRepo newBuilder buildFromMCVersion: mcVersion.
			self mcPackageRepo storeMCPackage: mcPackage ].
		
	duration := Time millisecondClockValue - startTS.
	self logInfo: 'Imported ', mcVersion info name, ' in ', duration asString, 'ms.'
]

{ #category : #actions }
SPMonticelloImporter >> importMCVersion: mcVersion name: aFilename 	fromRepo: aRepoUrl [

	| mcPackage |

	mcVersion snapshot definitions isEmpty
		ifTrue: [ ^ self ].
	
	context
		doTransaction: 'Import Monticello package ', aFilename
		with: [ 
			mcPackage := self mcPackageRepo newBuilder buildFromMCVersion: mcVersion.
			self mcPackageRepo storeRepoUrl: aRepoUrl filename: aFilename package: mcPackage ].
		
	self logInfo: 'Package ', aFilename, ' imported'

]

{ #category : #utilities }
SPMonticelloImporter >> importMagritte1 [

	| references |
	
	"repo := MCHttpRepository location: 'http://source.lukas-renggli.ch/magritte' user: '' password: ''."

	references := Gofer new
		disablePackageCache ;
		"directory: 'Z:\Smalltalk\repos\Magritte' ;"
		directory: '/Users/jan/Smalltalk/Repos/Magritte';
		allResolved.
		
	"references := references select: [ :each | each packageName = 'Magritte-Model' ]."
	references := references sorted: [ :r1 :r2 | r1 versionNumber < r2 versionNumber ].
		
	references do: [ :each |
		self importGoferReference: each ]
]

{ #category : #utilities }
SPMonticelloImporter >> importMagritte2 [

	| references |
	
	references := Gofer new
		disablePackageCache ;
		"directory: 'Z:\Smalltalk\repos\Magritte' ;"
		directory: '/Users/jan/Smalltalk/Repos/Magritte2';
		allResolved.
		
	references := references sorted: [ :r1 :r2 | r1 versionNumber < r2 versionNumber ].

	references do: [ :each |
		self importGoferReference: each ]
]

{ #category : #utilities }
SPMonticelloImporter >> importMagritte3 [

	| references |
	
	references := Gofer new
		disablePackageCache ;
		"directory: 'Z:\Smalltalk\repos\Magritte' ;"
		directory: '/Users/jan/Smalltalk/Repos/Magritte3';
		allResolved.
		
	references := references sorted: [ :r1 :r2 | r1 versionNumber < r2 versionNumber ].

	references do: [ :each |
		self importGoferReference: each ]
]

{ #category : #initialization }
SPMonticelloImporter >> initWithContext: aSPiderContext [

	context := aSPiderContext.
	mcPackageRepo := aSPiderContext mcPackageRepo
]

{ #category : #accessing }
SPMonticelloImporter >> mcPackageRepo [
	^ mcPackageRepo
]
