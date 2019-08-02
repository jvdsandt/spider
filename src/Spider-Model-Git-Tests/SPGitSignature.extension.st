Extension { #name : #SPGitSignature }

{ #category : #'*Spider-Model-Git-Tests' }
SPGitSignature >> withCurrentDatetime [

	^ self class name: name 
			email: email 
			datetime: DateAndTime new
			offset: Duration zero
]
