Class {
	#name : #SpiderDescriptorSystemTest,
	#superclass : #TestCase,
	#instVars : [
		'dummySession'
	],
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #accessing }
SpiderDescriptorSystemTest >> createDummySession [

	| login accessor |
	
	login := 	Login new
		database: PostgreSQLPlatform new;
		username: 'dummy';
		password: 'dummy';
		connectString: 'dummy';
		encodingStrategy: #utf8;
		yourself.
		
	accessor := DatabaseAccessor forLogin: login.
	^ SpiderDescriptorSystem sessionForAccessor: accessor
]

{ #category : #accessing }
SpiderDescriptorSystemTest >> dummySession [

	^ dummySession ifNil: [ dummySession := self createDummySession ]
]

{ #category : #tests }
SpiderDescriptorSystemTest >> testAllDescriptors [

	| system descriptors |
	
	system := self dummySession system.

	descriptors := system allDescriptors.
	self deny: descriptors isEmptyOrNil 
]

{ #category : #tests }
SpiderDescriptorSystemTest >> testCreateInstance [

	| instance |
	
	instance := SpiderDescriptorSystem new.
	self assert: instance notNil.
	
	instance := SpiderDescriptorSystem forPlatform: PostgreSQLPlatform new.
	self assert: instance notNil.
]

{ #category : #tests }
SpiderDescriptorSystemTest >> testDescriptors [

	| system |
	
	system := self dummySession system.

	(SPGlorp allSubclasses reject: [ :each | each isAbstract ]) do: [ :each |
		| descriptor |
		descriptor := system descriptorFor: each.
		self assert: descriptor notNil ]
]
