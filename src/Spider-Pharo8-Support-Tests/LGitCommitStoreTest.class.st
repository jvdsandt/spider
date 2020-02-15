Class {
	#name : #LGitCommitStoreTest,
	#superclass : #TestCase,
	#instVars : [
		'store',
		'lgitRepo'
	],
	#category : #'Spider-Pharo8-Support-Tests'
}

{ #category : #running }
LGitCommitStoreTest >> latestCommit [

	^ lgitRepo head object 
]

{ #category : #running }
LGitCommitStoreTest >> lgitCommit_1bfc2c7 [

	| c |
	c := lgitRepo revparse: '1bfc2c7'.
	self assert: c class equals: LGitCommit.
	^ c
]

{ #category : #accessing }
LGitCommitStoreTest >> reference [
	^ FileSystem disk workingDirectory / '_store_test_repo_'
]

{ #category : #running }
LGitCommitStoreTest >> setUp [ 
	super setUp.
	self setUpRepo.
	store := FileSystem onGitCommit: self lgitCommit_1bfc2c7.
]

{ #category : #running }
LGitCommitStoreTest >> setUpRepo [

	self tearDownRepo.
	
	lgitRepo := LGitRepository on: self reference.
	lgitRepo cloneHttps: 'https://github.com/jvdsandt/spider-gittest.git'.
]

{ #category : #accessing }
LGitCommitStoreTest >> tearDownRepo [
	self reference in: [ :ref | ref exists 
		ifFalse: [  ^ self  ]
		ifTrue: [ [ ref deleteAll ]
			on: FileDoesNotExistException
			do: [ "ignore. Seems to be a glitch in the File plugin" ] ] ]
]

{ #category : #running }
LGitCommitStoreTest >> testRoot [

	| root |
	
	root := store root.
]

{ #category : #running }
LGitCommitStoreTest >> testRootEntries [

	| root entries |
	
	root := store root.
	entries := root entries.
	entries := entries sorted: [ :e1 :e2 | e1 basename <= e2 basename ].
	
	self assert: entries size equals: 5.
	self assert: (entries collect: [ :e | e basename ]) equals: 
		#( '.project' '.properties' 'LICENSE' 'README.md' 'src' ).
	self assert: (entries collect: [ :e | e fileSize ]) equals: 
		#( 27 21 1065 64 0 ).
	
	self assert: (entries allSatisfy: [ :e | e isReadable ]).
	self assert: (entries allSatisfy: [ :e | e isWritable not ]).
	self assert: (entries allSatisfy: [ :e | e posixPermissions = 8r444 ]).
	
	
	
]

{ #category : #running }
LGitCommitStoreTest >> testTonelReader [

	| root reader snapshot |
	
	root := store root.
	
	reader := TonelReader on: store root / 'src' fileName: 'Spider-GitDemo1'.
	reader loadDefinitions.
	snapshot := reader snapshot.
	
	self assert: snapshot definitions size equals: 20.
	
	
]
