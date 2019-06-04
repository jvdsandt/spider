Extension { #name : #SPGlorpTransaction }

{ #category : #'*Spider-Model-Git' }
SPGlorpTransaction >> gitCommits [

	| query |
	
	query := Query read: SPGitCommit where: [ :each | each transaction = self ].
	
	^ self glorpSession execute: query
]
