Extension { #name : #SPiderContext }

{ #category : #'*Spider-Model-Git' }
SPiderContext >> createGitRepo [ 

	^ SPGitImageRepository new
			setContext: self;
			yourself
]

{ #category : #'*Spider-Model-Git' }
SPiderContext >> gitRepo [

	^ repos at: #gitRepo ifAbsentPut: [ self createGitRepo ]
]
