Class {
	#name : #SPPackageRDBRepository,
	#superclass : #SPPackageRepository,
	#instVars : [
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #accessing }
SPPackageRDBRepository >> classIdOf: aSpiderClass [

	^ aSpiderClass id isNil
		ifTrue: [ self classRepo storeClass: aSpiderClass ]
		ifFalse: [ aSpiderClass id ]
]

{ #category : #'accessing - queries' }
SPPackageRDBRepository >> deletePackageByIdQuery [

	| sql |
	
	sql := 'DELETE FROM packages WHERE id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #queries }
SPPackageRDBRepository >> getAllPackageNames [

	| query |
	
	query := (Query read: SPPackage)
		retrieve: [ :e | e name distinct ];
		orderBy: [ :e | e name ];
		yourself.

	^ self glorpSession execute: query
]

{ #category : #queries }
SPPackageRDBRepository >> getClassCategoryFor: aSpiderClassId in: aPackageId [

	| q row |
	
	q := Query readOneOf: SPPackageToClassRef 
		where: [ :e | e packageId = aPackageId AND: [ e spiderClassId = aSpiderClassId ] ].
	q retrieve: [ :e | e package name ].
	q retrieve: [ :e | e category ].
	
	row := self glorpSession execute: q.
	row isNil
		ifTrue: [ ^ nil ].
	^ row last isNil
			ifTrue: [ row first ]
			ifFalse: [ row first, '-', row last ]
]

{ #category : #queries }
SPPackageRDBRepository >> getPackageByHash: aBytes ifAbsent: aBlock [

	| package |
	
	package := self glorpSession readOneOf: SPPackage where: [ :e | e packageHash = aBytes ].
	^ package isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ package ]
]

{ #category : #queries }
SPPackageRDBRepository >> getPackageById: anId [

	^ self glorpSession readOneOf: SPPackage where: [ :e | e id = anId ]
]

{ #category : #queries }
SPPackageRDBRepository >> getPackageById: anId ifAbsent: aBlock [

	| p |
	
	p := self getPackageById: anId.
	^ p ifNil: aBlock ifNotNil: [ p ]
]

{ #category : #queries }
SPPackageRDBRepository >> getPackageNamesLike: aString max: aLimit [

	| q |
	
	q := Query read: SPPackage where: [ :e | e name ilike: aString ].
	q retrieve: [ :e | e name distinct ].
	q orderBy: [ :e | e name ].
	q limit: aLimit.
	
	^ self glorpSession execute: q
]

{ #category : #queries }
SPPackageRDBRepository >> getPackagesCreatedAfter: aDateAndTime [

	| q |
	
	q := (Query read: SPPackage where: [ :e | e transaction startedAt >= aDateAndTime ])
		orderBy: [ :e | e transaction startedAt descending ];
		yourself.

	^ self glorpSession execute: q
]

{ #category : #accessing }
SPPackageRDBRepository >> glorpSession [

	^ context glorpSession
]

{ #category : #'accessing - queries' }
SPPackageRDBRepository >> insertPackageClassRelQuery [

	| sql |
	
	sql := 'INSERT INTO package_cls_refs (package_id, class_id, category) VALUES ($1,$2,$3)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPPackageRDBRepository >> insertPackageQuery [

	| sql |
	
	sql := 'INSERT INTO packages (txid, name, hash, comment) VALUES ($1,$2,$3,$4) RETURNING (id)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #updating }
SPPackageRDBRepository >> replaceRefsTo: package1 with: package2 [

	(package1 = package2 and: [ package1 calcPackageHash = package2 calcPackageHash ])
		ifFalse: [ self error: 'Packages must be equal' ].
		
	self updateMCPackageRefsQuery execute: (Array 
			with: package1 id 
			with: package2 id).
			
	self updateGitCommitRefsQuery execute: (Array 
			with: package1 id 
			with: package2 id).

	self deletePackageByIdQuery execute: (Array with: package1 id)
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

{ #category : #'accessing - queries' }
SPPackageRDBRepository >> updateGitCommitRefsQuery [

	| sql |
	
	sql := 'UPDATE git_commit_pack_refs SET package_id = $2 WHERE package_id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #updating }
SPPackageRDBRepository >> updateHash: aPackage [

	| otherPackage |
	
	otherPackage := self getPackageByHash: aPackage packageHash ifAbsent: [ nil ].
	(otherPackage notNil and: [ otherPackage ~= aPackage ])
		ifTrue: [ self error: 'Packagehash no longer unique' ].
	
	otherPackage notNil
		ifTrue: [ 
			self replaceRefsTo: aPackage with: otherPackage ]
		ifFalse: [ 
			self updateHashQuery execute: (Array with: aPackage id with: aPackage packageHash) ]
]

{ #category : #'accessing - queries' }
SPPackageRDBRepository >> updateHashQuery [

	| sql |
	
	sql := 'UPDATE packages SET hash = $2 WHERE id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPPackageRDBRepository >> updateMCPackageRefsQuery [

	| sql |
	
	sql := 'UPDATE mc_packages SET package_id = $2 WHERE package_id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]
