Extension { #name : #SPPackage }

{ #category : #'*Spider-Model-MC' }
SPPackage >> oldestMCPackage [

	^ self currentContext mcPackageRepo getOldestMCPackageWithPackage: self id
]
