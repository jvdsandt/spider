Class {
	#name : #SPDiffRDBRepository,
	#superclass : #Object,
	#instVars : [
		'context',
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #'accessing - queries' }
SPDiffRDBRepository >> deleteDiffGitClassesByCommitIdQuery [

	| sql |
	
	sql := 'DELETE FROM diff_git_classes WHERE commit_id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPDiffRDBRepository >> deleteDiffGitMethodsByCommitIdQuery [

	| sql |
	
	sql := 'DELETE FROM diff_git_methods WHERE commit_id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPDiffRDBRepository >> deleteDiffGitPackagesByCommitIdQuery [

	| sql |
	
	sql := 'DELETE FROM diff_git_packages WHERE commit_id = $1'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #storing }
SPDiffRDBRepository >> deleteGitDiffsFromCommit: aCommitId [

	self deleteDiffGitMethodsByCommitIdQuery execute: aCommitId.
	self deleteDiffGitClassesByCommitIdQuery execute: aCommitId.
	self deleteDiffGitPackagesByCommitIdQuery execute: aCommitId.
]

{ #category : #queries }
SPDiffRDBRepository >> getAuthorAndCountsOfClassNamed: aName [

	| q |
	
	q := Query read: SPGitClassDiffRecord where: (self selectBlockForClassNamed: aName).
	q retrieve: [ :e | e commit authorSignature name ].
	q retrieve: [ :e | e countStar ].
	q groupBy: [ :e | e commit authorSignature name ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPDiffRDBRepository >> getAuthorAndCountsOfPackageNamed: aName [

	| q |
	
	q := Query read: SPGitPackageDiffRecord where: [ :e | e newPackage name = aName ].
	q retrieve: [ :e | e commit authorSignature name ].
	q retrieve: [ :e | e countStar ].
	q groupBy: [ :e | e commit authorSignature name ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPDiffRDBRepository >> getAuthorAndCountsOfSelector: aName [

	| q |
	
	q := Query read: SPGitMethodDiffRecord where: [ :e | e newMethod selector = aName ].
	q retrieve: [ :e | e commit authorSignature name ].
	q retrieve: [ :e | e countStar ].
	q groupBy: [ :e | e commit authorSignature name ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPDiffRDBRepository >> getAuthorsOfClassNamed: aName [

	| q aType |
	
	aType := SPGlorpClass classType.
	q := Query read: SPGitClassDiffRecord where: 
		[ :e | ((e oldClass asOuterJoin name = aName) AND: (e oldClass type = aType)) OR: (
				(e newClass asOuterJoin name = aName) AND: (e newClass type = aType)) ].
		
	q retrieve: [ :e | e commit authorSignature name distinct ].
	q retrieve: [ :e | e commit authorSignature email ].
	q orderBy: [ :e | e commit authorSignature name ].

	^ (self glorpSession execute: q) collect: [ :each |
			SPGitAuthor name: each first email: each last ]
]

{ #category : #queries }
SPDiffRDBRepository >> getCommitOfClass: aClass in: aGitRootId [

	| q |
	
	q := Query readOneOf: SPGitClassDiffRecord where: 
		[ :e | e commit rootId = aGitRootId AND: (e newClass = aClass) ].
		
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime ].

	^ (self glorpSession execute: q) ifNotNil: [ :diff | diff commit ]
]

{ #category : #queries }
SPDiffRDBRepository >> getCommitOfMethod: aMethod className: aClassName meta: isMeta in: aGitRootId [

	| q |
	
	q := Query readOneOf: SPGitMethodDiffRecord where: 
		[ :e | e commit rootId = aGitRootId AND: (e className = aClassName) AND: (e isMeta = isMeta) AND: (e newMethod = aMethod) ].
		
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime ].

	^ (self glorpSession execute: q) ifNotNil: [ :diff | diff commit ]
]

{ #category : #queries }
SPDiffRDBRepository >> getCommitOfPackage: aPackage in: aGitRootId [

	| q |
	
	q := Query readOneOf: SPGitPackageDiffRecord where: 
		[ :e | e commit rootId = aGitRootId AND: (e newPackage = aPackage) ].
		
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime ].

	^ (self glorpSession execute: q) ifNotNil: [ :diff | diff commit ]
]

{ #category : #queries }
SPDiffRDBRepository >> getGitRootIdsForClassNamed: aName [

	| q |
	
	q := Query read: SPGitClassDiffRecord where: 
		[ :e | e oldClass asOuterJoin name = aName OR: [ e newClass asOuterJoin name = aName ] ].
	q retrieve: [ :e | e commit rootId distinct ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPDiffRDBRepository >> getNewestCommitWithClassNamed: aName [

	| q list |
	
	q := Query read: SPGitClassDiffRecord where: (self selectBlockForClassNamed: aName).
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime descending ].
	q limit: 1.

	list := self glorpSession execute: q.
	^ list isEmpty
			ifTrue: [ nil ]
			ifFalse: [ list first commit ]
]

{ #category : #queries }
SPDiffRDBRepository >> getNewestCommitWithSelector: aName [

	| q list |
	
	q := Query read: SPGitMethodDiffRecord where: [ :e | e newMethod selector = aName ].
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime descending ].
	q limit: 1.

	list := self glorpSession execute: q.
	^ list isEmpty
			ifTrue: [ nil ]
			ifFalse: [ list first commit ]
]

{ #category : #queries }
SPDiffRDBRepository >> getOldestCommitWithClassNamed: aName [

	| q list |
	
	q := Query read: SPGitClassDiffRecord where: (self selectBlockForClassNamed: aName).
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime ].
	q limit: 1.

	list := self glorpSession execute: q.
	^ list isEmpty
			ifTrue: [ nil ]
			ifFalse: [ list first commit ]
]

{ #category : #queries }
SPDiffRDBRepository >> getOldestCommitWithSelector: aName [

	| q list |
	
	q := Query read: SPGitMethodDiffRecord where: [ :e | e newMethod selector = aName ].
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime ].
	q limit: 1.

	list := self glorpSession execute: q.
	^ list isEmpty
			ifTrue: [ nil ]
			ifFalse: [ list first commit ]
]

{ #category : #queries }
SPDiffRDBRepository >> gitVersionsOfClass: aName type: aType [

	| q |
	
	q := Query read: SPGitClassDiffRecord where: 
		[ :e | ((e oldClass asOuterJoin name = aName) AND: (e oldClass type = aType)) OR: (
				(e newClass asOuterJoin name = aName) AND: (e newClass type = aType)) ].
		
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime descending ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPDiffRDBRepository >> gitVersionsOfClass: aName type: aType in: aGitRootId [

	| q |
	
	q := Query read: SPGitClassDiffRecord where: 
		[ :e | e commit rootId = aGitRootId AND: (
			((e oldClass asOuterJoin name = aName) AND: (e oldClass type = aType)) OR: (
				(e newClass asOuterJoin name = aName) AND: (e newClass type = aType))) ].
		
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime descending ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPDiffRDBRepository >> gitVersionsOfMethod: aSelector className: aClassName meta: isMeta in: aGitRootId [

	| q |
	
	q := Query read: SPGitMethodDiffRecord where: 
		[ :e | e commit rootId = aGitRootId AND: (e className = aClassName) AND: (e isMeta = isMeta) AND: (
			(e oldMethod asOuterJoin selector = aSelector) OR: (e newMethod asOuterJoin selector = aSelector)) ].
		
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime descending ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPDiffRDBRepository >> gitVersionsOfPackageNamed: aName [

	| q |
	
	q := Query read: SPGitPackageDiffRecord where: 
		[ :e | (e oldPackage asOuterJoin name = aName) OR: (e newPackage asOuterJoin name = aName) ].
		
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime descending ].

	^ self glorpSession execute: q
]

{ #category : #queries }
SPDiffRDBRepository >> gitVersionsOfPackageNamed: aName in: aGitRootId [

	| q |
	
	q := Query read: SPGitPackageDiffRecord where: 
		[ :e | e commit rootId = aGitRootId AND: (
			(e oldPackage asOuterJoin name = aName) OR: (e newPackage asOuterJoin name = aName)) ].
		
	q alsoFetch: [ :e | e commit ].
	q orderBy: [ :e | e commit authorSignature datetime descending ].

	^ self glorpSession execute: q
]

{ #category : #accessing }
SPDiffRDBRepository >> glorpSession [

	^ context glorpSession
]

{ #category : #'accessing - queries' }
SPDiffRDBRepository >> insertDiffGitClassesQuery [

	| sql |
	
	sql := 'INSERT INTO diff_git_classes (commit_id, old_class_id, new_class_id) VALUES ($1,$2,$3)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPDiffRDBRepository >> insertDiffGitMethodsQuery [

	| sql |
	
	sql := 'INSERT INTO diff_git_methods (commit_id, class_name, meta, old_method_id, new_method_id) VALUES ($1,$2,$3,$4,$5)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #'accessing - queries' }
SPDiffRDBRepository >> insertDiffGitPackagesQuery [

	| sql |
	
	sql := 'INSERT INTO diff_git_packages (commit_id, old_package_id, new_package_id) VALUES ($1,$2,$3)'.
	^ queries at: sql ifAbsentPut: [ queries createQuery: sql ]
]

{ #category : #internal }
SPDiffRDBRepository >> selectBlockForClassNamed: aName [

	^ [ :e | (e newClass name = aName) AND: (e newClass type = SPGlorpClass classType) ]
]

{ #category : #initialization }
SPDiffRDBRepository >> setContext: aSpiderContext [

	context := aSpiderContext
]

{ #category : #storing }
SPDiffRDBRepository >> storeGitClassDiffs: aRecords [

	self insertDiffGitClassesQuery executeBatch: (
		aRecords collect: [ :each |
			Array 
				with: 	each commit id
				with: (each oldClass ifNotNil: [ :p | p id ])
				with: (each newClass ifNotNil: [ :p | p id ]) ])
]

{ #category : #storing }
SPDiffRDBRepository >> storeGitMethodDiffs: aRecords [

	self insertDiffGitMethodsQuery executeBatch: (
		aRecords collect: [ :each |
			Array 
				with: 	each commit id
				with: each className
				with: each isMeta
				with: (each oldMethod ifNotNil: [ :p | p id ])
				with: (each newMethod ifNotNil: [ :p | p id ]) ])
]

{ #category : #storing }
SPDiffRDBRepository >> storeGitPackageDiffs: aRecords [

	self insertDiffGitPackagesQuery executeBatch: (
		aRecords collect: [ :each |
			Array 
				with: 	each commit id
				with: (each oldPackage ifNotNil: [ :p | p id ])
				with: (each newPackage ifNotNil: [ :p | p id ]) ])
]
