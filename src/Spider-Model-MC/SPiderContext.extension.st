Extension { #name : #SPiderContext }

{ #category : #'*Spider-Model-MC' }
SPiderContext >> createMCPackageRepo [ 

	^ SPMonticelloPackageImageRepository new
			setContext: self;
			yourself
]
