Extension { #name : #LGitCommitStore }

{ #category : #'*Spider-Model-Git' }
LGitCommitStore >> basicIsSymlink: aNode [
	^ false
]

{ #category : #'*Spider-Model-Git' }
LGitCommitStore >> basicModificationTimeOf: aLGitTreeEntry [ 
	
	^ commit time asDateAndTime
]

{ #category : #'*Spider-Model-Git' }
LGitCommitStore >> basicPosixPermissions: aLGitTreeEntry [ 
	
	^ 8r444
]
