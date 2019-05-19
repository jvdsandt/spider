Extension { #name : #SPiderContext }

{ #category : #'*Spider-Model-Git' }
SPiderContext >> createGitRepo [ 

	^ SPGitImageRepository new
			setContext: self;
			yourself
]
