Class {
	#name : #SPGitLibGitDiff,
	#superclass : #Object,
	#instVars : [
		'newPackages',
		'updatedPackages',
		'removedPackages'
	],
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'instance creation' }
SPGitLibGitDiff class >> forFormat: aSymbol [

	aSymbol = #filetree
		ifTrue: [ ^ SPFileTreeLibGitDiff new ].
		
	aSymbol = #tonel
		ifTrue: [ ^ SPTonelLibGitDiff new ].
		
	self error: 'Unknown format'
]

{ #category : #'as yet unclassified' }
SPGitLibGitDiff >> handleDelta: lgitDelta [

	| newFile oldFile path |
	
	newFile := lgitDelta newFile.
	oldFile := lgitDelta oldFile.
	self logInfo: (newFile ifNotNil: [ :f | f path ]) asString, ' --> ', (oldFile ifNotNil: [ :f | f path ]) asString.
	
	path := (newFile ifNil: [ oldFile ]) path.
	(self isPackagePath: path)
		ifTrue: [ self updatedPackages add: (self packageNameFromPath: path) ]
]

{ #category : #initialization }
SPGitLibGitDiff >> initWithOld: oldCommit oldSourceDir: oldPath new: newCommit newSourceDir: newPath [

	| oldTree newTree diff |
	
	oldTree := oldCommit tree.
	oldPath isEmptyOrNil
		ifFalse: [ oldTree := (oldTree entryByPath: oldPath) object ].
		
	newTree := newCommit tree.
	newPath isEmptyOrNil
		ifFalse: [ newTree := (newTree entryByPath: newPath) object ].
		
	diff := oldTree diffTo: newTree.
	diff filesDo: [ :delta :second :third |
		self handleDelta: delta.
		0 ].
	
	
]

{ #category : #testing }
SPGitLibGitDiff >> isPackagePath: aPath [

	^ aPath includes: $/
]

{ #category : #'as yet unclassified' }
SPGitLibGitDiff >> packageNameFromPath: dirName [

	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
SPGitLibGitDiff >> updatedPackages [

	^ updatedPackages ifNil: [ updatedPackages := OrderedCollection new ]
]
