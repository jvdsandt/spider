Class {
	#name : #SPImporter,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#classVars : [
		'DatabaseUrl'
	],
	#category : #'Spider-Import-MC'
}

{ #category : #utilities }
SPImporter class >> createContext [

	^ (SPiderPostgreSQLContext openOnUrl: self databaseUrl)
			logging: false;
			yourself
]

{ #category : #accessing }
SPImporter class >> databaseUrl [ 

	^ DatabaseUrl
]

{ #category : #accessing }
SPImporter class >> databaseUrl: anUrl [

	DatabaseUrl := anUrl
]

{ #category : #'instance creation' }
SPImporter class >> newWithContext: aSPiderContext [

	^ self new initWithContext: aSPiderContext
]

{ #category : #accessing }
SPImporter >> context [
	^ context
]

{ #category : #initialization }
SPImporter >> initWithContext: aSPiderContext [

	context := aSPiderContext.

]
