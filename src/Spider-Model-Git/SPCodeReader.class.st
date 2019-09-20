Class {
	#name : #SPCodeReader,
	#superclass : #Object,
	#instVars : [
		'fileReference'
	],
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'instance creation' }
SPCodeReader class >> on: aFileReference [

	^ self new on: aFileReference
]

{ #category : #'instance creation' }
SPCodeReader class >> onLGitCommit: lgitCommit format: aFormatSymbol sourceDir: aSourceDir [

	
]

{ #category : #'API-packages' }
SPCodeReader >> getPackageFileRef: aPackageName ifAbsent: aBlock [

	self subclassResponsibility
]

{ #category : #'API-packages' }
SPCodeReader >> getPackageSha: aPackageName [
	"Answer the sha of the tree of <aPackageName> or nil if not present.
	This method only works with a LibGit FileSystemStore."

	| ref store lgitCommit |
	
	ref := self getPackageFileRef: aPackageName ifAbsent: [ ^ nil ].
	store := 	ref fileSystem store.
	(store isKindOf: LGitCommitStore)
		ifFalse: [ ^ nil ].
		
	lgitCommit := store instVarNamed: #commit.
	^ (lgitCommit tree entryByPath: ref pathString ifAbsent: [ ^ nil ]) objectId hexString
]

{ #category : #'API-packages' }
SPCodeReader >> getPackageSnapshot: aPackageName [

	^ self getPackageSnapshot: aPackageName ifAbsent: [ self error: 'Package not found: ', aPackageName printString ]
]

{ #category : #'API-packages' }
SPCodeReader >> getPackageSnapshot: aPackageName ifAbsent: aBlock [

	self subclassResponsibility
]

{ #category : #initialization }
SPCodeReader >> on: aFileReference [

	fileReference := aFileReference
]
