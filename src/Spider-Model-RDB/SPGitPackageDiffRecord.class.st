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
SPGitPackageDiffRecord >> newPackage [
	^ newPackage
]

{ #category : #accessing }
SPGitPackageDiffRecord >> oldPackage [
	^ oldPackage
]
