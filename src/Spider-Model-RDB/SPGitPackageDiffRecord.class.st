Class {
	#name : #SPGitPackageDiffRecord,
	#superclass : #SPGitDiffRecord,
	#instVars : [
		'newPackage',
		'oldPackage'
	],
	#category : #'Spider-Model-RDB-Diff'
}

{ #category : #initialization }
SPGitPackageDiffRecord >> initWith: aCommit old: old new: new [

	commit := aCommit.
	oldPackage := old.
	newPackage := new.
]

{ #category : #accessing }
SPGitPackageDiffRecord >> name [

	^ self newPackage notNil
		ifTrue: [ self newPackage name ]
		ifFalse: [ self oldPackage name ]
]

{ #category : #accessing }
SPGitPackageDiffRecord >> newHashLabel [
	^ newPackage ifNotNil: [ newPackage packageHashLabel ]
]

{ #category : #accessing }
SPGitPackageDiffRecord >> newPackage [
	^ newPackage
]

{ #category : #accessing }
SPGitPackageDiffRecord >> oldHashLabel [
	^ oldPackage ifNotNil: [ oldPackage packageHashLabel ]
]

{ #category : #accessing }
SPGitPackageDiffRecord >> oldPackage [
	^ oldPackage
]
