Class {
	#name : #SPGitClassDiffRecord,
	#superclass : #SPGitDiffRecord,
	#instVars : [
		'classType',
		'newClass',
		'oldClass'
	],
	#category : #'Spider-Model-RDB-Diff'
}

{ #category : #accessing }
SPGitClassDiffRecord >> classType [
	^ classType
]

{ #category : #initialization }
SPGitClassDiffRecord >> initWith: aCommit old: old new: new [

	commit := aCommit.
	oldClass := old.
	newClass := new.
]

{ #category : #accessing }
SPGitClassDiffRecord >> newClass [
	^ newClass
]

{ #category : #accessing }
SPGitClassDiffRecord >> oldClass [
	^ oldClass
]

{ #category : #accessing }
SPGitClassDiffRecord >> oldClassId [
	^ oldClass
]
