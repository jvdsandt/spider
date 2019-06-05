Class {
	#name : #SPPackageRDBRepositoryTest,
	#superclass : #SPiderTestCase,
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #accessing }
SPPackageRDBRepositoryTest class >> resources [

	^ super resources, (Array with: SPiderContextTestResource)
]

{ #category : #running }
SPPackageRDBRepositoryTest >> createContext [

	^ SPiderContextTestResource current context
]

{ #category : #running }
SPPackageRDBRepositoryTest >> setUp [

	super setUp.
	SPiderContextTestResource current resetForPackages
]

{ #category : #running }
SPPackageRDBRepositoryTest >> tearDown [

	context := nil.
	super tearDown
]

{ #category : #tests }
SPPackageRDBRepositoryTest >> testSimplePackage [

	| repo spiderClass package packageId p2 |
	
	repo := self packageRepo.
	
	spiderClass := repo classRepo newClassBuilder
		setClass: Boolean;
		build.

	package := SPPackage name: 'MyBooleanPackage'
		classRefs: (Array with: (SPPackageToClassRef spiderClass: spiderClass category: 'MyCat')) 
		comment: 'Just testing ...'.
		
	packageId := repo storePackage: package.
	
	p2 := repo getPackageById: packageId.
	self assert: p2 name equals: 'MyBooleanPackage'.
	self assert: p2 comment equals: 'Just testing ...'.
	self assert: p2 classNames equals: #( Boolean ).
	
	p2 := repo getPackageByHash: package packageHash ifAbsent: [ self fail: 'Package not found' ]
]

{ #category : #tests }
SPPackageRDBRepositoryTest >> testStoreRPackage [

	| repo package p2 |
	
	repo := self packageRepo.
	
	package := repo newBuilder 
		setRPackage: (RPackage organizer packageNamed: 'Spider-Model-Core');
		build.
	self assert: package classExtensionNames notEmpty.
	
	repo storePackage: package.
	
	p2 := repo getPackageByHash: package packageHash ifAbsent: [ self fail: 'Package not found' ].
	self assert: package name equals: p2 name.
	
	self assert: p2 classExtensionNames notEmpty.
	self assert: package classExtensions sorted equals: p2 classExtensions sorted.
]
