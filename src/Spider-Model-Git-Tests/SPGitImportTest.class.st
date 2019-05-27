Class {
	#name : #SPGitImportTest,
	#superclass : #SPGitCommitIceBuilderTest,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitImportTest >> assertFirstCommit: spCommit [

	self assert: spCommit gitId equals: '82a2d283d1e0c256fd61b6e8377e52e739d854fa'.
	self assert: spCommit authorName equals: 'Jan van de Sandt'.
	self assert: spCommit message equals: 'First commit with an empty package Spider-GitDemo1'.
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).
	self assert: spCommit parents isEmpty
]

{ #category : #accessing }
SPGitImportTest >> assertSecondCommit: spCommit [

	| package |

	self assert: spCommit gitId equals: '3035b8e242265147e9e5ae24da03e3bbbeaac4da'.
	self assert: spCommit authorName equals: 'Jan van de Sandt'.
	self assert: spCommit message equals: 'Added class SpiderGitDemoClass1'.
	self assert: spCommit packageNames equals: #( 'Spider-GitDemo1' ).
	
	package := spCommit packages first.
	self assert: package classNames equals: #( SpiderGitDemoClass ).
	self assert: package classExtensionNames equals: #().

	self assert: spCommit parents size equals: 1.
	self assertFirstCommit: spCommit parents first.
]

{ #category : #accessing }
SPGitImportTest >> createIceRepo [

	^ IceLibgitRepository new
		name: 'Spider-GitTest';
		location: self class baseDirectory asFileReference / 'Spider-GitTest';
		init;
		yourself.	
]

{ #category : #accessing }
SPGitImportTest >> testBuildCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo head commit.
	builder := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	
	spCommit inspect
]

{ #category : #accessing }
SPGitImportTest >> testFirstCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo revparse: '82a2d28'.

	builder := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	
	self assertFirstCommit: spCommit
]

{ #category : #accessing }
SPGitImportTest >> testMoveOfSourceDirectory [

	| iceCommit spCommit spParentCommit |
	
	iceCommit := self iceRepo revparse: 'a938376'.
	
	self assert: iceCommit project sourceDirectory equals: 'src'.
	self assert: iceCommit ancestors first project sourceDirectory equals: ''.

	spCommit := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		build.
	spParentCommit := spCommit parents first.
	
	self assert: spCommit packages equals: spParentCommit packages.


]

{ #category : #accessing }
SPGitImportTest >> testSecondsCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo revparse: '3035b8e'.

	spCommit := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		build.
	
	self assertSecondCommit: spCommit
]

{ #category : #accessing }
SPGitImportTest >> testTonelParse [

	| file doc |
	
	file := 'D:\stdev\jvdsandt\P3\P3\P3PreparedStatement.class.st' asFileReference.
	
	doc := file readStreamDo: [ :s | TonelParser parseStream: s ]
]

{ #category : #accessing }
SPGitImportTest >> testTonelParseExtension [

	| file doc |
	
	file := 'D:\stdev\jvdsandt\P3\P3\ScaledDecimal.extension.st' asFileReference.
	
	doc := file readStreamDo: [ :s | TonelParser parseStream: s ]
]
