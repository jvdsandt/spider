Class {
	#name : #SPClassRDBRepository,
	#superclass : #SPClassRepository,
	#instVars : [
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #'accessing - queries' }
SPClassRDBRepository >> deleteClassByIdQuery [

	| sql |
	
	sql := 'DELETE FROM classes WHERE id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #queries }
SPClassRDBRepository >> getClassByHash: aBytes ifAbsent: aBlock [

	| spiderClass |
	
	spiderClass := self glorpSession readOneOf: SPGlorpClass where: [ :each | each classHash = aBytes ].
	^ spiderClass isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ spiderClass ]

]

{ #category : #queries }
SPClassRDBRepository >> getClassById: anId [

	^ self getClassById: anId ifAbsent:  [ self error: 'SpiderClass not found' ]
]

{ #category : #queries }
SPClassRDBRepository >> getClassById: anId ifAbsent: aBlock [

	| spiderClass |
	
	spiderClass := self glorpSession readOneOf: SPGlorpClass where: [ :each | each id = anId ].
	spiderClass isNil
		ifTrue: [ ^ aBlock value ].
	^ spiderClass
]

{ #category : #queries }
SPClassRDBRepository >> getClassNames: aStringSearchCriteria max: aLimit [

	| q |
	
	q := Query read: SPGlorpClass where: aStringSearchCriteria asWhereNameBlock.
	q retrieve: [ :e | e name distinct ].
	q orderBy: [ :e | e name ].
	q limit: aLimit.
	
	^ self glorpSession execute: q
]

{ #category : #queries }
SPClassRDBRepository >> getClassNamesLike: aString max: aLimit [

	| q |
	
	q := Query read: SPGlorpClass where: [ :e | e name ilike: aString ].
	q retrieve: [ :e | e name distinct ].
	q orderBy: [ :e | e name ].
	q limit: aLimit.
	
	^ self glorpSession execute: q
]

{ #category : #accessing }
SPClassRDBRepository >> glorpSession [

	^ context glorpSession
]

{ #category : #'accessing - queries' }
SPClassRDBRepository >> insertClassQuery [

	| sql |
	
	sql := 'INSERT INTO classes (txid, type, name, hash, class_type, superclassname, inst_trait, class_trait, comment) 
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING (id)'.
	
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPClassRDBRepository >> insertMRelQuery [

	| sql |
	
	sql := 'INSERT INTO class_met_refs (class_id, type, method_id, category) VALUES ($1,$2,$3,$4)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPClassRDBRepository >> insertVarRelQuery [

	| sql |
	
	sql := 'INSERT INTO class_var_refs (class_id, type, variable, expression) VALUES ($1,$2,$3,$4)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #accessing }
SPClassRDBRepository >> methodIdOf: aMethod [

	^ aMethod id isNil
			ifTrue: [ self methodRepo storeMethod: aMethod ]
			ifFalse: [ aMethod id ]
]

{ #category : #updating }
SPClassRDBRepository >> replaceRefsTo: spiderClass1 with: spiderClass2 [

	(spiderClass1 = spiderClass2 and: [ spiderClass1 calcClassHash = spiderClass2 calcClassHash ])
		ifFalse: [ self error: 'Classes must be equal' ].
		
	self updatePackageRefsQuery execute: (Array 
			with: spiderClass1 id 
			with: spiderClass2 id).
			
	self deleteClassByIdQuery execute: (Array with: spiderClass1 id)
]

{ #category : #stroring }
SPClassRDBRepository >> storeClass: aSpiderClass [

	| spiderClass classId |

	aSpiderClass isSpiderClassExtension 
		ifTrue: [ ^ self storeClassExtension: aSpiderClass ].

	spiderClass := self getClassByHash: aSpiderClass classHash ifAbsent: [ nil ].
	spiderClass notNil
		ifTrue: [ ^ spiderClass id ].
		
	classId := self insertClassQuery getOne: (OrderedCollection new 
			add: self transactionId;
			add: aSpiderClass type;
			add: aSpiderClass name; 
			add: aSpiderClass classHash; 
			add: aSpiderClass classType; 
			add: aSpiderClass superclassName;
			add: aSpiderClass traitCompositionString;
			add: aSpiderClass classTraitCompositionString;  
			add: aSpiderClass comment;
			yourself).
	
	self storeMethodsOf: aSpiderClass withId: classId.
	self storeVariablesOf: aSpiderClass withId: classId.

	^ classId
]

{ #category : #stroring }
SPClassRDBRepository >> storeClassExtension: aClassExtension [

	| classExt classId |
	
	classExt := self getClassByHash: aClassExtension classHash ifAbsent: [ nil ].
	classExt notNil
		ifTrue: [ ^ classExt id ].
		
	classId := self insertClassQuery getOne: (OrderedCollection new
			add: self transactionId;
			add: aClassExtension type;
			add: aClassExtension name; 
			add: aClassExtension classHash;
			add: nil;
			add: nil;
			add: nil;
			add: nil;
			add: aClassExtension comment;
			yourself).
	
	self storeMethodsOf: aClassExtension withId: classId.

	^ classId
]

{ #category : #stroring }
SPClassRDBRepository >> storeMethodsOf: aSpiderClass withId: aClassId [

	| list |
	
	list := aSpiderClass methodRefs collect: [ :each |
		| methodId |
		methodId := self methodIdOf: each method.
		Array with: aClassId with: each type with: methodId with: each category ].

	self insertMRelQuery executeBatch: list
]

{ #category : #stroring }
SPClassRDBRepository >> storeVariablesOf: aSpiderClass withId: aClassId [

	| list |
	
	list := aSpiderClass variableRefs collect: [ :each |
		Array with: aClassId with: each type with: each variable with: each expressionOrNil ].
	
	self insertVarRelQuery executeBatch: list
]

{ #category : #'accessing - queries' }
SPClassRDBRepository >> updateCommentAndHashQuery [

	| sql |
	
	sql := 'UPDATE classes SET hash = $2, comment = $3 WHERE id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #updating }
SPClassRDBRepository >> updateHash: aSpiderClass [

	^ self updateHashQuery execute: (Array with: aSpiderClass id with: aSpiderClass classHash)
]

{ #category : #'accessing - queries' }
SPClassRDBRepository >> updateHashQuery [

	| sql |
	
	sql := 'UPDATE classes SET hash = $2 WHERE id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPClassRDBRepository >> updatePackageRefsQuery [

	| sql |
	
	sql := 'UPDATE package_cls_refs SET class_id = $2 WHERE class_id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]
