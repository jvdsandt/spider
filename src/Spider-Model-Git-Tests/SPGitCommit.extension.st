Extension { #name : #SPGitCommit }

{ #category : #'*Spider-Model-Git-Tests' }
SPGitCommit >> newChildWith: newPackage message: newMessage [

	| newPackages replaced newSignature dummySha |
	
	replaced := false.
	newPackages := packages 
		collect: [ :each |
			each name = newPackage name
				ifTrue: [ replaced := true. newPackage ]
				ifFalse: [ each ] ].
	replaced
		ifFalse: [ newPackages := newPackages copyWith: newPackage ].
		
	newSignature := authorSignature withCurrentDatetime.
	dummySha := SHA1 hashMessage: newSignature datetime asString.

	^ self class sha: dummySha 
			authorSignature: newSignature  
			message: newMessage 
			parents: (Array with: self) 
			packages: newPackages 
			status: status
			sourceDir: sourceDir 
			format: format
]
