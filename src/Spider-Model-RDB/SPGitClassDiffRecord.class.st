Class {
	#name : #SPGitClassDiffRecord,
	#superclass : #SPGitDiffRecord,
	#instVars : [
		'newClass',
		'oldClass'
	],
	#category : #'Spider-Model-RDB-Diff'
}

{ #category : #accessing }
SPGitClassDiffRecord >> classType [
	^ newClass notNil
			ifTrue: [ newClass type ]
			ifFalse: [ oldClass type ]
]

{ #category : #initialization }
SPGitClassDiffRecord >> initWith: aCommit old: old new: new [

	commit := aCommit.
	oldClass := old.
	newClass := new.
]

{ #category : #accessing }
SPGitClassDiffRecord >> name [

	^ self newClass notNil
		ifTrue: [ self newClass name ]
		ifFalse: [ self oldClass name ]
]

{ #category : #accessing }
SPGitClassDiffRecord >> newClass [
	^ newClass
]

{ #category : #accessing }
SPGitClassDiffRecord >> newHashLabel [
	^ newClass ifNotNil: [ newClass classHashLabel ]
]

{ #category : #accessing }
SPGitClassDiffRecord >> oldClass [
	^ oldClass
]

{ #category : #accessing }
SPGitClassDiffRecord >> oldHashLabel [
	^ oldClass ifNotNil: [ oldClass classHashLabel ]
]
