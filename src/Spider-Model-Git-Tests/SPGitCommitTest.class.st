Class {
	#name : #SPGitCommitTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #tests }
SPGitCommitTest >> testEquals [

	| sig c1 c2 |
	
	sig := SPGitSignature name: 'Pete' email: 'pete@home.nl' datetime: DateAndTime now offset: Duration zero.
	
	c1 := SPGitCommit sha: #[ 1 2 3 4 ] 
		authorSignature: sig 
		message: 'test msg' 
		parents: #() 
		packages: #() 
		status: #imported 
		sourceDir: 'src' 
		format: #tonel.

	c2 := SPGitCommit sha: #[ 1 2 3 4 ] 
		authorSignature: sig 
		message: 'test msg' 
		parents: #() 
		packages: #() 
		status: #imported 
		sourceDir: 'src' 
		format: #tonel.
		
	self assert: c1 equals: c2.
	self assert: c1 hash equals: c2 hash.

]

{ #category : #tests }
SPGitCommitTest >> testInstance [

	| sig c1|
	
	sig := SPGitSignature name: 'Pete' email: 'pete@home.nl' datetime: DateAndTime now offset: Duration zero.
	
	c1 := SPGitCommit sha: #[ 1 2 3 ] 
		authorSignature: sig 
		message: 'test msg' 
		parents: #() 
		packages: #() 
		status: #imported 
		sourceDir: 'src' 
		format: #tonel.

	self assert: c1 isImported.
	self deny: c1 isImportError.
]

{ #category : #tests }
SPGitCommitTest >> testSha [

	| sig c1 |
	
	sig := SPGitSignature name: 'Pete' email: 'pete@home.nl' datetime: DateAndTime now offset: Duration zero.
	
	c1 := SPGitCommit sha: #[ 1 2 3 4 5 6 7 8 9 0 101 102 103 104 105 106 107 108 109 110 ] 
		authorSignature: sig 
		message: 'test msg' 
		parents: #() 
		packages: #() 
		status: #imported 
		sourceDir: 'src' 
		format: #tonel.
	
	self assert: c1 shaString equals: '0102030405060708090065666768696a6b6c6d6e'.
	self assert: c1 shaShortString equals: '0102030'.
	self assert: c1 sha equals: #[ 1 2 3 4 5 6 7 8 9 0 101 102 103 104 105 106 107 108 109 110 ].
]

{ #category : #tests }
SPGitCommitTest >> testSignature [

	| sig c1 |
	
	sig := SPGitSignature name: 'Pete' email: 'pete@home.nl' datetime: DateAndTime now offset: Duration zero.
	
	c1 := SPGitCommit sha: #[ 1 2 3 4 5 6 7 8 9 0 101 102 103 104 105 106 107 108 109 110 ] 
		authorSignature: sig 
		message: 'test msg' 
		parents: #() 
		packages: #() 
		status: #imported 
		sourceDir: 'src' 
		format: #tonel.
	
	self assert: c1 datetime equals: sig datetime.
	self assert: c1 authorName equals: sig name.
	self assert: c1 authorEmail equals: sig email.
]
