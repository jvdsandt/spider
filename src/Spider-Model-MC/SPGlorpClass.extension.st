Extension { #name : #SPGlorpClass }

{ #category : #'*Spider-Model-MC' }
SPGlorpClass >> oldestMCPackage [

	^ self currentContext mcPackageRepo getOldestMCPackageWithClass: self id
]
