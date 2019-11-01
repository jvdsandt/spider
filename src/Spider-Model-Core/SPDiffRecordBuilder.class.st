Class {
	#name : #SPDiffRecordBuilder,
	#superclass : #SPDiffVisitor,
	#instVars : [
		'commit',
		'records',
		'currentClassName',
		'currentIsMeta'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #'as yet unclassified' }
SPDiffRecordBuilder class >> recordsForCommit: aCommit [

	^ self new recordsForCommit: aCommit
]

{ #category : #adding }
SPDiffRecordBuilder >> addRecord: aDiffRecord [

	^ records add: aDiffRecord
]

{ #category : #accessing }
SPDiffRecordBuilder >> commit [
	^ commit
]

{ #category : #accessing }
SPDiffRecordBuilder >> commitId [

	^ commit id
]

{ #category : #accessing }
SPDiffRecordBuilder >> currentClassName [
	^ currentClassName
]

{ #category : #accessing }
SPDiffRecordBuilder >> currentIsMeta [
	^ currentIsMeta
]

{ #category : #accessing }
SPDiffRecordBuilder >> records [
	^ records
]

{ #category : #'as yet unclassified' }
SPDiffRecordBuilder >> recordsForCommit: aCommit [

	commit := aCommit.
	records := OrderedCollection new.
	self visitAll: aCommit diffs.
	^ records
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffAddedClass: aDiff [

	self addRecord: (SPGitClassDiffRecord new initWith: self commit old: nil new: aDiff newClass id).
	
	currentClassName := aDiff newClass name.
	aDiff methodDiffs do: [ :each | 
		currentIsMeta := each newObject isClassSide.
		each accept: self ]
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffAddedMethod: aDiff [

	self addRecord: (SPGitMethodDiffRecord new initWith: self commit
			class: self currentClassName 
			meta: self currentIsMeta
			old: nil 
			new: aDiff newMethod)
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffAddedPackage: aDiff [

	self addRecord: (SPGitPackageDiffRecord new initWith: self commit old: nil new: aDiff newPackage).
	
	aDiff classDiffs do: [ :each | each accept: self ]
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffRemovedClass: aDiff [

	aDiff oldObjects do: [ :each |
		self addRecord: (SPGitClassDiffRecord new initWith: self commit old: each spiderClass new: nil) ].
	
	currentClassName := aDiff oldSpiderClass name.
	aDiff methodDiffs do: [ :each |
		currentIsMeta := each oldObject isClassSide.
		each accept: self ]
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffRemovedMethod: aDiff [

	aDiff oldObjects do: [ :each |
		self addRecord: (SPGitMethodDiffRecord new initWith: self commit
			class: self currentClassName 
			meta: self currentIsMeta 
			old: each
			new: nil) ]
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffRemovedPackage: aDiff [

	aDiff oldObjects do: [ :each |
		self addRecord: (SPGitPackageDiffRecord new initWith: self commit old: each new: nil) ].
	
	aDiff classDiffs do: [ :each | each accept: self ]
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffUpdatedClass: aDiff [

	aDiff oldObjects do: [ :each |
		self addRecord: (SPGitClassDiffRecord new initWith: self commit old: each spiderClass new: aDiff newSpiderClass) ].
	
	currentClassName := aDiff newSpiderClass name.
	aDiff methodDiffs do: [ :each |
		currentIsMeta := each newObject isClassSide.
		each accept: self ]
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffUpdatedMethod: aDiff [

	aDiff oldObjects do: [ :each |
		self addRecord: (SPGitMethodDiffRecord new initWith: self commit
			class: self currentClassName 
			meta: self currentIsMeta
			old: each
			new: aDiff newMethod) ]
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffUpdatedPackage: aDiff [

	aDiff oldObjects do: [ :each |
		self addRecord: (SPGitPackageDiffRecord new initWith: self commit old: each new: aDiff newPackage) ].
	
	aDiff classDiffs do: [ :each | each accept: self ]
]
