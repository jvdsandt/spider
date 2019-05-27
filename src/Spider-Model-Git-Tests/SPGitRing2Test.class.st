Class {
	#name : #SPGitRing2Test,
	#superclass : #SPGitCommitIceBuilderTest,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitRing2Test >> createIceRepo [

	^ IceLibgitRepository new
		name: 'Ring2';
		location: self class baseDirectory asFileReference / 'Ring2.git';
		yourself.	
]

{ #category : #accessing }
SPGitRing2Test >> testHeadCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo revparse: 'HEAD'.

	builder := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	
	spCommit inspect
]

{ #category : #accessing }
SPGitRing2Test >> testImportFirstSourceCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo revparse: 'f9f75f8'.

	builder := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	
	spCommit inspect
]

{ #category : #accessing }
SPGitRing2Test >> testImportSourceCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo revparse: '52e5297'.

	builder := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	
	spCommit inspect
]
