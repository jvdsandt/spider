Class {
	#name : #SPGitRepoTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Git-Tests'
}

{ #category : #tests }
SPGitRepoTest >> testGitHub [

	| repo |
	
	repo := SPGitRepo url: 'https://github.com/pharo-project/pharo.git'.
	self assert: repo url equals: 'https://github.com/pharo-project/pharo.git'.
	self assert: repo domain equals: 'GitHub'.
	self assert: repo owner equals: 'pharo-project'.
	self assert: repo name equals: 'pharo'

]
