Class {
	#name : #SpiderGlorpTest,
	#superclass : #TestCase,
	#instVars : [
		'accessor',
		'session',
		'system'
	],
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #initialization }
SpiderGlorpTest >> setUp [
	
	| login |

	PharoDatabaseAccessor DefaultDriver: P3DatabaseDriver.
	
	login := 	Login new
 	  database: PostgreSQLPlatform new;
		username: 'spreader';
		password: 'spreader';
		connectString: 'theraver5:5432_postgres';
		encodingStrategy: #utf8;
		yourself.
		
	accessor := DatabaseAccessor forLogin: login.
	accessor logging: true.
	accessor login.

	session := SpiderDescriptorSystem sessionForAccessor: accessor.
	system := session system.
	


]

{ #category : #initialization }
SpiderGlorpTest >> tearDown [ 

"	accessor notNil
		ifTrue: [ 
			accessor logout.
			accessor := nil ]"
]

{ #category : #tests }
SpiderGlorpTest >> testMCPackages [

	| packages |

	self assert: session notNil.
	
	packages := session read: SPGlorpMonticelloPackage.

]

{ #category : #tests }
SpiderGlorpTest >> testMCRepos [

	self assert: session notNil.
	
	(session read: SPGlorpMonticelloRepository) inspect.

]

{ #category : #tests }
SpiderGlorpTest >> testMethods [

	| query list |
	
	self assert: session notNil.
		
	query := Query read: SPMethod where: [ :each | each selector = #printOn: ].
	list := session execute: query.

	query := Query read: SPMethod where: [ :each | each classToMethodRefs anySatisfy: [ :c | c category = 'printing' ] ].
	list := session execute: query.
	list inspect

]

{ #category : #tests }
SpiderGlorpTest >> testPackages [

	| query |
	
	self assert: session notNil.
	
	(session read: SPPackage) inspect.
	
	query := Query read: SPPackage where: [ :each | each name like: #'Magritte%' ].
	(session execute: query) inspect

]

{ #category : #tests }
SpiderGlorpTest >> testSetup [

	self assert: session notNil.
	
	session readOneOf: SPMethod where: [ :each | each sourceHash = #[ 1 2 3 ] ].
	
	(session read: SPMethod where: [ :each | each selector = #printOn: ]) inspect.
	(session read: SPGlorpClass where: [ :each | each name = #MADescription ]) inspect.

	accessor inspect
	

]
