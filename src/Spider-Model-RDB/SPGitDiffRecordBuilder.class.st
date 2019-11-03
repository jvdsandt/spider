Class {
	#name : #SPGitDiffRecordBuilder,
	#superclass : #SPDiffVisitor,
	#instVars : [
		'commit',
		'packageRecords',
		'classRecords',
		'methodRecords',
		'currentClassName',
		'currentIsMeta'
	],
	#category : #'Spider-Model-RDB-Diff'
}

{ #category : #'as yet unclassified' }
SPGitDiffRecordBuilder class >> recordsForCommit: aCommit [

	^ self new recordsForCommit: aCommit
]

{ #category : #building }
SPGitDiffRecordBuilder >> build [

	self visitAll: commit diffs
]

{ #category : #building }
SPGitDiffRecordBuilder >> buildAndStoreWith: aDiffRepo [

	self build.
	
	aDiffRepo 
		deleteGitDiffsFromCommit: commit id;
		storeGitPackageDiffs: packageRecords;
		storeGitClassDiffs: classRecords;
		storeGitMethodDiffs: methodRecords
]

{ #category : #accessing }
SPGitDiffRecordBuilder >> classRecords [
	^ classRecords
]

{ #category : #accessing }
SPGitDiffRecordBuilder >> commit [
	^ commit
]

{ #category : #accessing }
SPGitDiffRecordBuilder >> currentClassName [
	^ currentClassName
]

{ #category : #accessing }
SPGitDiffRecordBuilder >> currentIsMeta [
	^ currentIsMeta
]

{ #category : #accessing }
SPGitDiffRecordBuilder >> methodRecords [
	^ methodRecords
]

{ #category : #accessing }
SPGitDiffRecordBuilder >> packageRecords [
	^ packageRecords
]

{ #category : #accessing }
SPGitDiffRecordBuilder >> recordCount [

	^ packageRecords size + classRecords size + methodRecords size
]

{ #category : #initialization }
SPGitDiffRecordBuilder >> setCommit: aGitCommit [

	commit := aGitCommit.
	methodRecords := OrderedCollection new.
	classRecords := OrderedCollection new.
	packageRecords := OrderedCollection new.
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffAddedClass: aDiff [

	classRecords add: (SPGitClassDiffRecord new initWith: commit old: nil new: aDiff newSpiderClass).
	
	currentClassName := aDiff newSpiderClass name.
	aDiff methodDiffs do: [ :each | 
		currentIsMeta := each isClassSide.
		each accept: self ]
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffAddedMethod: aDiff [

	methodRecords add: (SPGitMethodDiffRecord new initWith: commit
			class: self currentClassName 
			meta: self currentIsMeta
			old: nil 
			new: aDiff newMethod)
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffAddedPackage: aDiff [

	packageRecords add: (SPGitPackageDiffRecord new initWith: commit old: nil new: aDiff newPackage).
	
	aDiff classDiffs do: [ :each | each accept: self ]
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffRemovedClass: aDiff [

	aDiff oldObjects do: [ :each |
		classRecords add: (SPGitClassDiffRecord new initWith: commit old: each spiderClass new: nil) ].
	
	currentClassName := aDiff oldSpiderClass name.
	aDiff methodDiffs do: [ :each |
		currentIsMeta := each isClassSide.
		each accept: self ]
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffRemovedMethod: aDiff [

	aDiff oldObjects do: [ :each |
		methodRecords add: (SPGitMethodDiffRecord new initWith: commit
			class: self currentClassName 
			meta: self currentIsMeta 
			old: each method
			new: nil) ]
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffRemovedPackage: aDiff [

	aDiff oldObjects do: [ :each |
		packageRecords add: (SPGitPackageDiffRecord new initWith: commit old: each new: nil) ].
	
	aDiff classDiffs do: [ :each | each accept: self ]
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffUpdatedClass: aDiff [

	aDiff oldObjects do: [ :each |
		classRecords add: (SPGitClassDiffRecord new initWith: commit old: each spiderClass new: aDiff newSpiderClass) ].
	
	currentClassName := aDiff newSpiderClass name.
	aDiff methodDiffs do: [ :each |
		currentIsMeta := each isClassSide.
		each accept: self ]
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffUpdatedMethod: aDiff [

	aDiff oldObjects do: [ :each |
		methodRecords add: (SPGitMethodDiffRecord new initWith: commit
			class: self currentClassName 
			meta: self currentIsMeta
			old: each method
			new: aDiff newMethod) ]
]

{ #category : #visiting }
SPGitDiffRecordBuilder >> visitDiffUpdatedPackage: aDiff [

	aDiff oldObjects do: [ :each |
		packageRecords add: (SPGitPackageDiffRecord new initWith: commit old: each new: aDiff newPackage) ].
	
	aDiff classDiffs do: [ :each | each accept: self ]
]
