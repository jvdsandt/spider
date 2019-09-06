Class {
	#name : #SPFixSlotVariableRefs,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-FixScripts'
}

{ #category : #execution }
SPFixSlotVariableRefs >> execute [

	| result classIds packageIds |

	result := self p3client query: 'select distinct c.id from classes c where
	exists (select * from class_var_refs where c.id = class_id and variable like ''#%'')'.
	classIds := result data collect: [ :eachRow | eachRow first ].
	
	result := self p3client query: 'select distinct p.id from packages p where
	exists (select distinct package_id from package_cls_refs pcr where
		p.id = pcr.package_id and
		exists (select * from class_var_refs where pcr.class_id = class_id and variable like ''#%''))'.
	packageIds := result data collect: [ :eachRow | eachRow first ].
	
	classIds do: [ :each |
		| spiderClass |
		spiderClass := self classRepo getClassById: each.
		self fixSlotVariablesOf: spiderClass ].
	
	self rehashPackageIds: packageIds.
	

]

{ #category : #execution }
SPFixSlotVariableRefs >> fixSlotVariablesOf: aSpiderClass [

	self context 
		doTransaction: (self class name, ' - ', aSpiderClass name, ' - ', aSpiderClass id asString) asString
		with: [ self fixSlotVariablesOf: aSpiderClass txid: self context currentTransactionId ]
]

{ #category : #execution }
SPFixSlotVariableRefs >> fixSlotVariablesOf: aSpiderClass txid: txid [

	| statement otherClass |
	
	"fix the variables and recalculate the hash"
	aSpiderClass fixSlotVariableRefs.
	aSpiderClass initClassHash.
	
	otherClass := self classRepo getClassByHash: aSpiderClass classHash ifAbsent: [ nil ].
	(otherClass notNil and: [ otherClass id ~= aSpiderClass id ])
		ifTrue: [ self halt ].

	"delete the currect variables"
	statement := self p3client format: 'delete from class_var_refs where class_id = $1'.
	statement execute: (Array with: aSpiderClass id).
	
	"re-insert the variables and update the hash"
	self classRepo storeVariablesOf: aSpiderClass withId: aSpiderClass id.
	self classRepo updateHash: aSpiderClass.
	
	self logInfo: 'Fixed variables of ', aSpiderClass name, ' id: ', aSpiderClass id asString.
]

{ #category : #execution }
SPFixSlotVariableRefs >> rehashPackageIds: aList [

	self context 
		doTransaction: (self class name, ' - rehashing packages') asString
		with: [ self rehashPackageIds: aList txid: self context currentTransactionId ]
]

{ #category : #execution }
SPFixSlotVariableRefs >> rehashPackageIds: aList txid: txid [

	aList do: [ :eachId |
		| package oldHash |
		package := self packageRepo getPackageById: eachId.
		oldHash := package packageHash.
		package initPackageHash.
		package packageHash = oldHash 
			ifFalse: [ self packageRepo updateHash: package ] ].
		
	self logInfo: aList size printString, ' package hashes updated'
]
