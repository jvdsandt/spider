Class {
	#name : #SPGitRepoTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #tests }
SPGitRepoTest >> testGitHub [

	| repo |
	
	repo := SPGitRepo newFromUrl: 'https://github.com/pharo-project/pharo.git'.
	self assert: repo ownerName equals: 'pharo-project'.
	self assert: repo name equals: 'pharo'.
	self assert: repo url equals: 'https://github.com/pharo-project/pharo'.
]
