Class {
	#name : #SPGitImporter,
	#superclass : #Object,
	#instVars : [
		'context',
		'iceRepo'
	],
	#category : #'Spider-Import-MC-Spider-Import-MC'
}

{ #category : #'as yet unclassified' }
SPGitImporter class >> importGitTestRepo [

	| context instance iceRepo |
	
	context := SPiderImageContext new.
	instance := self newWithContext: context.

	iceRepo := IceLibgitRepository new
		name: 'Spider-GitTest';
		location: '/Users/jan/Projects/Spider-GitTest' asFileReference;
		init;
		yourself.	
		
	instance importCommit: iceRepo head commit.
]

{ #category : #'as yet unclassified' }
SPGitImporter class >> importGlorpRepo [

	| context instance iceRepo commits |
	
	context := SPiderImageContext new.
	instance := self newWithContext: context.

	iceRepo := IceLibgitRepository new
		name: 'Spider-GitTest';
		location: '/Users/jan/Projects/glorp' asFileReference;
		init;
		yourself.	

	commits := OrderedCollection new.
	
	iceRepo localBranches do: [ :each |
		each commit commitsDo: [ :eachCommit |
			commits addFirst: eachCommit ] ].
	
	commits do: [ :each |
		instance importCommit: each ]
]

{ #category : #'instance creation' }
SPGitImporter class >> newWithContext: aSPiderContext [

	^ self new initWithContext: aSPiderContext
]

{ #category : #actions }
SPGitImporter >> importCommit: iceCommit [

	| builder spCommit |
	
	builder := SPGitCommitIceBuilder new
		setContext: context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	context gitRepo storeCommit: spCommit
]

{ #category : #initialization }
SPGitImporter >> initWithContext: aSPiderContext [

	context := aSPiderContext
]
