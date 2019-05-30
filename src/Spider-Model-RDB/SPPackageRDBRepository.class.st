Class {
	#name : #SPPackageRDBRepository,
	#superclass : #SPPackageRepository,
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #accessing }
SPPackageRDBRepository >> classIdOf: aSpiderClass [

	^ aSpiderClass id isNil
		ifTrue: [ self classRepo storeClass: aSpiderClass ]
		ifFalse: [ aSpiderClass id ]
]

{ #category : #queries }
SPPackageRDBRepository >> getAllPackageNames [

	| query |
	
	query := (Query read: SPGlorpPackage)
		retrieve: [ :e | e name ];
		orderBy: [ :e | e name ];
		yourself.

	^ self glorpSession execute: query
]

{ #category : #queries }
SPPackageRDBRepository >> getPackageByHash: aBytes ifAbsent: aBlock [

	| package |
	
	package := self glorpSession readOneOf: SPGlorpPackage where: [ :e | e packageHash = aBytes ].
	^ package isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ package ]
]

{ #category : #queries }
SPPackageRDBRepository >> getPackageById: anId [

	^ self glorpSession readOneOf: SPGlorpPackage where: [ :e | e id = anId ]
]

{ #category : #accessing }
SPPackageRDBRepository >> glorpSession [

	^ context glorpSession
]

{ #category : #storing }
SPPackageRDBRepository >> storePackage: aPackage [

	| package packageId rows |
	
	package := self getPackageByHash: aPackage packageHash ifAbsent: [ nil ].
	package notNil
		ifTrue: [ ^ package id ].
			
	packageId := self insertPackageQuery getOne: (
		Array 
			with: self transactionId
			with: aPackage name 
			with: aPackage packageHash 
			with: aPackage comment).
	
	rows := aPackage classRefs collect: [ :each |
		| classId |
		classId := self classIdOf: each spiderClass.
		Array with: packageId with: classId with: each category ].
	self insertPackageClassRelQuery executeBatch: rows.	
	
	^ packageId
]

{ #category : #storing }
SPPackageRDBRepository >> updateHash: aPackage [

	^ self updateHashQuery execute: (Array with: aPackage id with: aPackage packageHash)
]
