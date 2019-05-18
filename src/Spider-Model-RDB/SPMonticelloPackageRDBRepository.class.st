Class {
	#name : #SPMonticelloPackageRDBRepository,
	#superclass : #SPMonticelloPackageRepository,
	#instVars : [
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #queries }
SPMonticelloPackageRDBRepository >> getMCPackageAncestorsById: anId [

	^ (self getMCPackageById: anId) ancestors
]

{ #category : #queries }
SPMonticelloPackageRDBRepository >> getMCPackageById: anId [

	| query mcPackage |
	
	query := (Query readOneOf: SPGlorpMonticelloPackage where: [ :each | each id = anId ])
		shouldRefresh: true;
		yourself.

	mcPackage := self glorpSession execute: query.
	mcPackage isNil
		ifTrue: [ self error: 'MCPackage not found' ].
	^ mcPackage
]

{ #category : #queries }
SPMonticelloPackageRDBRepository >> getMCPackageByName: aName andMcId: aBytes ifAbsent: aBlock [

	| mcPackage |
	
	mcPackage := self glorpSession readOneOf: SPGlorpMonticelloPackage 
		where: [ :e | e name = aName AND: [ e mcId = aBytes ] ].

	^ mcPackage isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ mcPackage ]
]

{ #category : #queries }
SPMonticelloPackageRDBRepository >> getMCPackageForRepo: aRepoUrl andFile: aFilename ifAbsent: aBlock [

	| mcPackageRef |
	
	mcPackageRef := self glorpSession readOneOf: SPGlorpMonticelloRepoToPackageRef where: [ :e |
		e repository repoUrl = aRepoUrl AND: [ e filename = aFilename ] ].
	
	^ mcPackageRef isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ mcPackageRef mcPackage ]
]

{ #category : #queries }
SPMonticelloPackageRDBRepository >> getMCRepoByUrl: anUrl ifAbsent: aBlock [

	| mcRepo |
	
	mcRepo := self glorpSession readOneOf: SPGlorpMonticelloRepository where: [ :e | e repoUrl = anUrl ].
	^ mcRepo isNil
		ifTrue: [ aBlock value ]
		ifFalse: [ mcRepo ]
]

{ #category : #internal }
SPMonticelloPackageRDBRepository >> getPackageId: aMCPackage [

	^ aMCPackage package ifNotNil: [ :p | self packageRepo storePackage: p ]
]

{ #category : #accessing }
SPMonticelloPackageRDBRepository >> glorpSession [

	^ context glorpSession
]

{ #category : #queries }
SPMonticelloPackageRDBRepository >> hasFile: aFilename fromRepo: aRepoUrl [

	^ (self getMCPackageForRepo: aRepoUrl andFile: aFilename ifAbsent: [ nil ]) notNil
]

{ #category : #'accessing - queries' }
SPMonticelloPackageRDBRepository >> insertMCPackageAncestorQuery [

	| sql |
	
	sql := 'INSERT INTO mc_package_ancestors (mc_package_id, mc_ancestor_id) VALUES ($1,$2)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPMonticelloPackageRDBRepository >> insertMCPackageQuery [

	| sql |
	
	sql := 'INSERT INTO mc_packages (txid, mc_id, name, datetime, author, version, message, branch, package_id)
VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING (id)'.
	
	^queries at: sql ifAbsentPut: [ 
		queries createQuery: sql 
				input: [ :input |
					{
						self transactionId.
						input mcId.
						input name.
						input datetime.
						input author.
						input version.
						input message.
						input branch.
						(self getPackageId: input)
					} ] ]
]

{ #category : #'accessing - queries' }
SPMonticelloPackageRDBRepository >> insertMCRepoPackageQuery [

	| sql |
	
	sql := 'INSERT INTO mc_repo_pack_refs (mc_repo_id, mc_package_id, txid, filename) VALUES ($1,$2,$3,$4)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPMonticelloPackageRDBRepository >> insertMCRepoQuery [

	| sql |
	
	sql := 'INSERT INTO mc_repos (txid, repo_url) VALUES ($1,$2) RETURNING (id)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #storing }
SPMonticelloPackageRDBRepository >> storeMCPackage: aMCPackage [

	| mcPackage mcPackageId ancestorIds packageId rootId |
	
	mcPackage := self getMCPackageByName: aMCPackage name andMcId: aMCPackage mcId ifAbsent: [ nil ].
	mcPackage notNil
		ifTrue: [ 
			mcPackageId := mcPackage id.
			(mcPackage package isNil and: [ aMCPackage package notNil ])
				ifTrue: [ 
					packageId := self packageRepo storePackage: aMCPackage package.
					self updateMCPackagePackageQuery execute: (Array with: packageId with: mcPackageId) ].
			^ mcPackageId ].
		
	"First store the ancestor packages"
	ancestorIds := aMCPackage ancestors collect: [ :each | self storeMCPackage: each ].
			
	"Then the new package"
	mcPackageId := self insertMCPackageQuery getOne: aMCPackage.
	
	"Then create the relation between the new package and its ancestors"
	self insertMCPackageAncestorQuery executeBatch: (
		ancestorIds collect: [ :eachAncestorId | Array with: mcPackageId with: eachAncestorId ]).
		
	"Finally set the root_id of the new package"
	rootId := ancestorIds isEmpty
		ifTrue: [ mcPackageId ]
		ifFalse: [ (self getMCPackageById: ancestorIds first) rootId ].
	self updateMCPackageRootdIdQuery execute: (Array with: rootId with: mcPackageId).
	
	^ mcPackageId
]

{ #category : #storing }
SPMonticelloPackageRDBRepository >> storeRepoUrl: anUrl filename: aFilename package: aMCPackage [

	| mcPackageId mcRepo mcRepoId |
	
	mcPackageId := self storeMCPackage: aMCPackage.
	mcRepo := self getMCRepoByUrl: anUrl ifAbsent: [ nil ].
	mcRepoId := mcRepo isNil
		ifTrue: [ self insertMCRepoQuery getOne: (Array with: self transactionId with: anUrl) ]
		ifFalse: [ mcRepo id ].
		
	self insertMCRepoPackageQuery execute: (
		Array with: mcRepoId with: mcPackageId with: self transactionId with: aFilename).

]

{ #category : #storing }
SPMonticelloPackageRDBRepository >> updateMCPackage: aMCPackage package: aPackage [

	| mcPackage packageId |
	
	mcPackage := self getMCPackageByName: aMCPackage name andMcId: aMCPackage mcId 
		ifAbsent: [ self error: 'MCPackage not found' ].

	mcPackage package notNil
		ifTrue: [ self error: 'MCPackage with package expected' ].

	packageId := self packageRepo storePackage: aPackage.
	self updateMCPackagePackageQuery execute: (Array with: packageId with: mcPackage id).
	
	^self getMCPackageById: mcPackage id
]

{ #category : #'accessing - queries' }
SPMonticelloPackageRDBRepository >> updateMCPackagePackageQuery [

	| sql |
	
	sql := 'UPDATE mc_packages SET package_id = $1 WHERE id = $2'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPMonticelloPackageRDBRepository >> updateMCPackageRootdIdQuery [

	| sql |
	
	sql := 'UPDATE mc_packages SET root_id = $1 WHERE id = $2'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]