Class {
	#name : #SPClassRDBRepository,
	#superclass : #SPClassRepository,
	#category : #'Spider-Model-RDB-Repos'
}

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

	| spiderClass |
	
	spiderClass := self glorpSession readOneOf: SPGlorpClass where: [ :each | each id = anId ].
	spiderClass isNil
		ifTrue: [ self error: 'SpiderClass not found' ].
	^ spiderClass
]

{ #category : #accessing }
SPClassRDBRepository >> glorpSession [

	^ context glorpSession
]

{ #category : #accessing }
SPClassRDBRepository >> methodIdOf: aMethod [

	^ aMethod id isNil
			ifTrue: [ self methodRepo storeMethod: aMethod ]
			ifFalse: [ aMethod id ]
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

{ #category : #stroring }
SPClassRDBRepository >> updateHash: aSpiderClass [

	^ self updateHashQuery execute: (Array with: aSpiderClass id with: aSpiderClass classHash)
]
