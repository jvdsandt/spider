Class {
	#name : #SPGitMethodDiffRecord,
	#superclass : #SPGitDiffRecord,
	#instVars : [
		'className',
		'isMeta',
		'newMethod',
		'oldMethod'
	],
	#category : #'Spider-Model-RDB-Diff'
}

{ #category : #accessing }
SPGitMethodDiffRecord >> className [
	^ className
]

{ #category : #initialization }
SPGitMethodDiffRecord >> initWith: aCommit class: aClassName meta: aBool old: old new: new [

	commit := aCommit.
	className := aClassName.
	isMeta := aBool.
	oldMethod := old.
	newMethod := new.
]

{ #category : #accessing }
SPGitMethodDiffRecord >> isMeta [
	^ isMeta
]

{ #category : #accessing }
SPGitMethodDiffRecord >> newMethod [
	^ newMethod
]

{ #category : #accessing }
SPGitMethodDiffRecord >> oldMethod [
	^ oldMethod
]
