Extension { #name : #SPiderContext }

{ #category : #'*Spider-Model-MC' }
SPiderContext >> createMCPackageRepo [ 

	^ SPMonticelloPackageImageRepository new
			setContext: self;
			yourself
]

{ #category : #'*Spider-Model-MC' }
SPiderContext >> mcPackageRepo [

	^ repos at: #mcPackageRepo ifAbsentPut: [ self createMCPackageRepo ]
]
