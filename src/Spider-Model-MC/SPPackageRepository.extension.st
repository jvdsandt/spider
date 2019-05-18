Extension { #name : #SPPackageRepository }

{ #category : #'*Spider-Model-MC' }
SPPackageRepository >> newMCBuilder [

	^ SPPackageMCBuilder new
			setRepo: self;
			yourself
]
