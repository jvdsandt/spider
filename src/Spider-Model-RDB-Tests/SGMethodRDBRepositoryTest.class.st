Class {
	#name : #SGMethodRDBRepositoryTest,
	#superclass : #SGMethodRepositoryTest,
	#classVars : [
		'Url'
	],
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #accessing }
SGMethodRDBRepositoryTest class >> resources [

	^ super resources, (Array with: SPiderContextTestResource)
]

{ #category : #running }
SGMethodRDBRepositoryTest >> createContext [

	^ SPiderContextTestResource current context
]

{ #category : #running }
SGMethodRDBRepositoryTest >> setUp [

	super setUp.
	SPiderContextTestResource current resetForMethods 
]

{ #category : #running }
SGMethodRDBRepositoryTest >> tearDown [

	context := nil.
	super tearDown
]

{ #category : #tests }
SGMethodRDBRepositoryTest >> testMethod [

	| repo id1 id2 method m2 |
	
	repo := self methodRepo.
	self assert: #() equals: repo allVariables asArray.
	
	method := self methodBuilder
		setSource: 'hello
	self theMessage';
		build.

	id1 := repo storeMethod: method.
	self assert: id1 isInteger.
	id2 := repo storeMethod: method.
	self assert: id1 equals: id2.
	
	m2 := repo selectMethodByHash: method sourceHash ifAbsent: [ self fail: 'method not found' ].
	self assert: method selector equals: m2 selector.
	self assert: method sourceHash equals: m2 sourceHash.
	self assert: method selectorRefs sorted equals: m2 selectorRefs sorted.
	self assert: method pragmas isEmpty.
]

{ #category : #tests }
SGMethodRDBRepositoryTest >> testMethodInBulk [

	| repo ids |
	
	repo := self methodRepo.
	ids := Dictionary new.
	
	Set methodDictionary do: [ :eachCM |
		| method id |
		method := self methodBuilder 
			setCompiledMethod: eachCM;
			build.
		id := repo storeMethod: method.
		ids at: eachCM selector put: id ].

	Set methodDictionary do: [ :eachCM |
		| method id |
		method := self methodBuilder 
			setCompiledMethod: eachCM;
			build.
		id := repo storeMethod: method.
		self assert: (ids at: eachCM selector) equals: id ].

]

{ #category : #tests }
SGMethodRDBRepositoryTest >> testMethodWithVariableAccess [

	| repo id1 id2 method m2 |
	
	repo := self methodRepo.
	self assert: #() equals: repo allVariables asArray.
	
	method := self methodBuilder
		setSource: 'hello
	| c |
	a := 1000.
	b = 2000 ifFalse: [ c := 10 ].
	self theMessage';
		build.

	id1 := repo storeMethod: method.
	self assert: #( a b ) equals: repo allVariables.
	id2 := repo storeMethod: method.
	self assert: id1 equals: id2.
	
	m2 := repo selectMethodByHash: method sourceHash ifAbsent: [ self fail: 'method not found' ].
	self assert: method selector equals: m2 selector.
	self assert: method sourceHash equals: m2 sourceHash.
	self assert: method messages sorted equals: m2 messages sorted.
	self assert: method pragmas isEmpty.
]

{ #category : #tests }
SGMethodRDBRepositoryTest >> testPragma [

	| repo id1 id2 method m2 |
	
	repo := self methodRepo.
	
	method := self methodBuilder
		setSource: 'hello
	<blabla: 123>
	self theMessage';
		build.

	self assert: method pragmas equals: #( blabla: ).
	
	id1 := repo storeMethod: method.
	self assert: id1 isInteger.
	id2 := repo storeMethod: method.
	self assert: id1 equals: id2.
	
	m2 := repo selectMethodByHash: method sourceHash ifAbsent: [ self fail: 'method not found' ].
	self assert: method selector equals: m2 selector.
	self assert: method sourceHash equals: m2 sourceHash.
	self assert: method messages sorted equals: m2 messages sorted.
	self assert: method pragmas equals: m2 pragmas.
]

{ #category : #tests }
SGMethodRDBRepositoryTest >> testPragma2 [

	| repo id1 id2 method m2 |
	
	repo := self methodRepo.
	
	method := self methodBuilder
		setSource: 'hello
	<blabla: 123>
	self theMessage.
	super blabla: 12.
	self blabla: 45.
	true blabla: false.';
		build.

	self assert: method messages equals: #( blabla: theMessage ).
	self assert: method pragmas equals: #( blabla: ).
	self assert: (method selectorRefAt: #blabla:) isToSelf.
	self assert: (method selectorRefAt: #blabla:) isToSuper.
	
	id1 := repo storeMethod: method.
	self assert: id1 isInteger.
	id2 := repo storeMethod: method.
	self assert: id1 equals: id2.
	
	m2 := repo selectMethodByHash: method sourceHash ifAbsent: [ self fail: 'method not found' ].
	self assert: method selector equals: m2 selector.
	self assert: method sourceHash equals: m2 sourceHash.
	self assert: method messages sorted equals: m2 messages sorted.
	self assert: method pragmas equals: m2 pragmas.
]

{ #category : #tests }
SGMethodRDBRepositoryTest >> testSendersOf [

	| m1 m2 senders |
	
	m1 := self methodBuilder
		setSource: 'hello
	self theMessage';
		build.
	self methodRepo storeMethod: m1.

	m2 := self methodBuilder
		setSource: 'hello2
	self otherMessage: 3';
		build.
	self methodRepo storeMethod: m2.

	senders := self methodRepo sendersOf: #theMessage.
	self assert: 1 equals: senders size.
	self assert: m1 sourceHash equals: senders first sourceHash.
	
	senders := self methodRepo sendersOf: #otherMessage:.
	self assert: 1 equals: senders size.
	self assert: m2 sourceHash equals: senders first sourceHash.
]
