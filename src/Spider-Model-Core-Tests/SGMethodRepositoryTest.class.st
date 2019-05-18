Class {
	#name : #SGMethodRepositoryTest,
	#superclass : #SPiderTestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #tests }
SGMethodRepositoryTest >> methodBuilder [ 

	^ self methodRepo newBuilder
]

{ #category : #tests }
SGMethodRepositoryTest >> testCompiledMethod: cm in: repo [

	| m1 m2 id1 id2 m3 |
	
	m1 := self methodBuilder 
		setCompiledMethod: cm;
		build.

	m2 := self methodBuilder 
		setCompiledMethod: cm;
		build.

	self assert: m1 sourceHash equals: m2 sourceHash.
	
	id1 := repo storeMethod: m1.
	id2 := repo storeMethod: m2.
	self assert: id1 equals: id2.
	
	m3 := repo selectMethodByHash: m1 sourceHash ifAbsent: [ self fail: 'not found' ].
	self assert: m1 selector equals: m3 selector.
	self assert: m1 sourceHash equals: m3 sourceHash.
	self assert: m1 messages sorted equals: m3 messages sorted.
	self assert: m1 variableRefs sorted equals: m3 variableRefs sorted.
	self assert: m1 pragmas sorted equals: m3 pragmas sorted.
]

{ #category : #tests }
SGMethodRepositoryTest >> testMethod [

	| repo id1 id2 method m2 |
	
	repo := self methodRepo.
	self assert: #() equals: repo allVariables asArray.
	
	method := self methodBuilder
		setSource: 'hello
	self theMessage';
		build.

	id1 := repo storeMethod: method.
	id2 := repo storeMethod: method.
	self assert: id1 equals: id2.
	
	m2 := repo selectMethodByHash: method sourceHash ifAbsent: [ self fail: 'method not found' ].
	self assert: method selector equals: m2 selector.
	self assert: method sourceHash equals: m2 sourceHash.
	self assert: method selectorRefs sorted equals: m2 selectorRefs sorted.
]

{ #category : #tests }
SGMethodRepositoryTest >> testMethodInBulk [

	| repo ids |
	
	repo := self methodRepo.
	ids := Dictionary new.
	
	Collection methodDictionary do: [ :eachCM |
		| method id |
		method := self methodBuilder 
			setCompiledMethod: eachCM;
			build.
		id := repo storeMethod: method.
		ids at: eachCM selector put: id ].

	Collection methodDictionary do: [ :eachCM |
		| method id |
		method := self methodBuilder 
			setCompiledMethod: eachCM;
			build.
		id := repo storeMethod: method.
		self assert: (ids at: eachCM selector) equals: id ].

]

{ #category : #tests }
SGMethodRepositoryTest >> testMethodInBulk2 [

	| repo |
	
	repo := self methodRepo.
	
	Collection methodDictionary do: [ :eachCM |
		self testCompiledMethod: eachCM in: repo ].	

]

{ #category : #tests }
SGMethodRepositoryTest >> testMethodNotEmpty [

	| repo cm |
	
	repo := self methodRepo.
	
	cm := Collection >> #notEmpty.
	
	self testCompiledMethod: cm in: repo.
]
