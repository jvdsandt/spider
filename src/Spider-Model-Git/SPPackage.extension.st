Extension { #name : #SPPackage }

{ #category : #'*Spider-Model-Git' }
SPPackage >> oldestGitCommit [

	^ self currentContext gitRepo getOldestCommitWithPackage: self id
]
