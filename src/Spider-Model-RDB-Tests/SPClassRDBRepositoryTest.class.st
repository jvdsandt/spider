Class {
	#name : #SPClassRDBRepositoryTest,
	#superclass : #SPiderTestCase,
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #accessing }
SPClassRDBRepositoryTest class >> resources [

	^ super resources, (Array with: SPiderContextTestResource)
]

{ #category : #running }
SPClassRDBRepositoryTest >> createContext [

	^ SPiderContextTestResource current context
]

{ #category : #running }
SPClassRDBRepositoryTest >> setUp [

	super setUp.
	SPiderContextTestResource current resetForClasses
]

{ #category : #running }
SPClassRDBRepositoryTest >> tearDown [

	context := nil.
	super tearDown
]

{ #category : #tests }
SPClassRDBRepositoryTest >> testBuildClassTwice [

	| repo c1 c2 |
	
	repo := self classRepo.
	
	c1 := repo newClassBuilder
		setClass: Boolean;
		build.
	repo storeClass: c1.

	c2 := repo newClassBuilder
		setClass: Boolean;
		build.

	self assert: c1 equals: c2
]

{ #category : #tests }
SPClassRDBRepositoryTest >> testStoreBooleanClass [

	| repo spiderClass classId1 classId2 spiderClass2 |
	
	repo := self classRepo.
	
	spiderClass := repo newClassBuilder
		setClass: Boolean;
		build.
		
	classId1 := repo storeClass: spiderClass.
	classId2 := repo storeClass: spiderClass.
	self assert: classId1 equals: classId2.
	self assert: classId1 == classId2.
	
	spiderClass2 := repo getClassByHash: spiderClass classHash ifAbsent: [ self fail: 'Class not found' ].
	self assert: spiderClass name equals: spiderClass2 name.
	self assert: spiderClass classType equals: spiderClass2 classType.
	self assert: spiderClass superclassName equals: spiderClass2 superclassName.
	self assert: spiderClass classHash equals: spiderClass2 classHash.
	self assert: spiderClass instanceMethodRefs sorted equals: spiderClass2 instanceMethodRefs sorted.
	
	spiderClass2 := repo getClassById: classId1.
	self assert: spiderClass name equals: spiderClass2 name.
	self assert: spiderClass classType equals: spiderClass2 classType.
	self assert: spiderClass superclassName equals: spiderClass2 superclassName.
	self assert: spiderClass classHash equals: spiderClass2 classHash.
	self assert: spiderClass instanceMethodRefs sorted equals: spiderClass2 instanceMethodRefs sorted.

]

{ #category : #tests }
SPClassRDBRepositoryTest >> testStoreClassExtension [

	| repo classExt id classExt2 |
	
	repo := self classRepo.
	
	classExt := SPClassExtensionBuilder new
		setClass: Object instMethods: (Array with: Object >> #externalCallFailed) classMethods: #();
		build.
	
	id := repo storeClassExtension: classExt.
		
	classExt2 := repo getClassByHash: classExt classHash ifAbsent: [ self fail: 'ClassExt not found' ].
	self assert: classExt2 name equals: #Object.
	self assert: classExt2 isSpiderClassExtension.
	self assert: classExt2 instanceSelectors equals: #( externalCallFailed ).
	self assert: classExt2 classSelectors equals: #().
	
	classExt2 := repo getClassById: id.
	self assert: classExt2 name equals: #Object.
	self assert: classExt2 isSpiderClassExtension.

]

{ #category : #tests }
SPClassRDBRepositoryTest >> testStoreClassWithSlots [

	| repo class c2 |
	
	repo := self classRepo.
	class := SPClassBuilder new
		setClass: SlotExampleMovie;
		build.
	repo storeClass: class.
		
	c2 := repo getClassByHash: class classHash ifAbsent: [ self fail: 'No class' ].
	
	self assert: #SlotExampleMovie equals: c2 name.
	self assert: #normal equals: c2 classType.
	
	self assert: c2 instanceVarNames sorted equals: SlotExampleMovie instVarNames sorted.
	
	self assert: (c2 instanceVarRefNamed: #name) expression equals: '#name'.
	self assert: (c2 instanceVarRefNamed: #director) expression equals: '#director => ToOneRelationSlot inverse: #directedMovies inClass: #SlotExamplePerson'.
	
	


]

{ #category : #tests }
SPClassRDBRepositoryTest >> testStoreCollectionClass [

	| repo spiderClass classId1 classId2 |
	
	repo := self classRepo.
	
	spiderClass := repo newClassBuilder
		setClass: Collection;
		build.
		
	classId1 := repo storeClass: spiderClass.
	classId2 := repo storeClass: spiderClass.
	
	self assert: classId1 equals: classId2.
]

{ #category : #tests }
SPClassRDBRepositoryTest >> testStoreCollectionClasses [

	| repo |
	
	repo := self classRepo.
	
	OrderedCollection withAllSubclassesDo: [ :eachClass |
		| spiderClass classId1 classId2 |
	
		spiderClass := repo newClassBuilder
			setClass: eachClass;
			build.
		
		classId1 := repo storeClass: spiderClass.
		classId2 := repo storeClass: spiderClass.
	
		self assert: classId1 equals: classId2 ].
]

{ #category : #tests }
SPClassRDBRepositoryTest >> testStoreTrait [

	| repo spiderClass classId1 classId2 spiderClass2 |
	
	repo := self classRepo.
	
	spiderClass := repo newClassBuilder
		setClass: SPTestTrait;
		build.
	self assert: spiderClass isSpiderTrait.
	
	classId1 := repo storeClass: spiderClass.
	classId2 := repo storeClass: spiderClass.
	self assert: classId1 equals: classId2.
	self assert: classId1 == classId2.
	
	spiderClass2 := repo getClassByHash: spiderClass classHash ifAbsent: [ self fail: 'Trait not found' ].
	self assert: spiderClass2 isSpiderTrait.
	self assert: spiderClass name equals: spiderClass2 name.
	self assert: spiderClass classType equals: spiderClass2 classType.
	self assert: spiderClass classHash equals: spiderClass2 classHash.
	self assert: spiderClass instanceMethodRefs sorted equals: spiderClass2 instanceMethodRefs sorted.
	
	spiderClass2 := repo getClassById: classId1.
	self assert: spiderClass2 isSpiderTrait.
	self assert: spiderClass name equals: spiderClass2 name.
	self assert: spiderClass classType equals: spiderClass2 classType.
	self assert: spiderClass classHash equals: spiderClass2 classHash.
	self assert: spiderClass instanceMethodRefs sorted equals: spiderClass2 instanceMethodRefs sorted.

]
