Class {
	#name : #SPGitGlorpTest,
	#superclass : #SPGitCommitIceBuilderTest,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #accessing }
SPGitGlorpTest >> createIceRepo [

	^ IceLibgitRepository new
		name: 'glorp';
		location: self class baseDirectory asFileReference / 'glorp';
		yourself
]

{ #category : #accessing }
SPGitGlorpTest >> testGlorpFirstCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo revparse: 'b48ce2b'.

	builder := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	
	spCommit inspect
]

{ #category : #accessing }
SPGitGlorpTest >> testGlorpHeadCommit [

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
SPGitGlorpTest >> testGlorpMergeCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo revparse: 'afed9a2'.

	builder := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	
		spCommit inspect
	
	
]

{ #category : #accessing }
SPGitGlorpTest >> testGlorpSecondCommit [

	| iceCommit builder spCommit |
	
	iceCommit := self iceRepo revparse: '23c460a'.

	builder := SPGitCommitIceBuilder new
		setContext: self context;
		setIceCommit: iceCommit;
		yourself.
		
	spCommit := builder build.
	
	spCommit inspect
]
