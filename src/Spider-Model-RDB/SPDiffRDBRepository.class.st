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
