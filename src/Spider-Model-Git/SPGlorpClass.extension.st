Extension { #name : #SPGlorpClass }

{ #category : #'*Spider-Model-Git' }
SPGlorpClass >> oldestGitCommit [

	^ self currentContext gitRepo getOldestCommitWithClass: self id
]
