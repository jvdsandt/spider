Class {
	#name : #SPPackageNameInfo,
	#superclass : #Object,
	#instVars : [
		'name',
		'gitRootId',
		'gitRepos',
		'oldestGitCommit',
		'newestGitCommit',
		'gitAuthors',
		'mcAuthors',
		'mcRepos',
		'versionCount',
		'newestMCPackage',
		'oldestMCPackage'
	],
	#category : #'Spider-Web-API'
}

{ #category : #accessing }
SPPackageNameInfo >> gitAuthorNames [

	^ (self gitAuthors collect: [ :each | each name ]) asSet sorted
]

{ #category : #accessing }
SPPackageNameInfo >> gitAuthors [
	^ gitAuthors
]

{ #category : #accessing }
SPPackageNameInfo >> gitRepos [
	^ gitRepos
]

{ #category : #accessing }
SPPackageNameInfo >> gitRootId [
	^ gitRootId
]

{ #category : #initialization }
SPPackageNameInfo >> initWithName: aName gitRootId: anId [

	name := aName.
	gitRootId := anId
]

{ #category : #accessing }
SPPackageNameInfo >> mcAuthors [
	^ mcAuthors
]

{ #category : #accessing }
SPPackageNameInfo >> mcRepos [
	^ mcRepos
]

{ #category : #accessing }
SPPackageNameInfo >> name [
	^ name
]

{ #category : #accessing }
SPPackageNameInfo >> newestGitCommit [
	^ newestGitCommit
]

{ #category : #accessing }
SPPackageNameInfo >> newestMCPackage [
	^ newestMCPackage
]

{ #category : #accessing }
SPPackageNameInfo >> oldestGitCommit [
	^ oldestGitCommit
]

{ #category : #accessing }
SPPackageNameInfo >> oldestMCPackage [
	^ oldestMCPackage
]

{ #category : #initialization }
SPPackageNameInfo >> retrieveInfo: aContext [

	versionCount := aContext gitRepo packageRepo countOfPackagesNamed: name.
	versionCount = 0
		ifTrue: [ ^ self ].

	gitRepos := aContext gitRepo getReposWithPackageNamed: name.
	oldestGitCommit := aContext gitRepo getOldestCommitWithPackageNamed: name.
	newestGitCommit := aContext gitRepo getNewestCommitWithPackageNamed: name.
	gitAuthors := aContext gitRepo getAuthorsOfPackageNamed: name.
	
	mcRepos := aContext mcPackageRepo getMCReposWithPackageNamed: name.
	oldestMCPackage := aContext mcPackageRepo getOldestMCPackageWithPackageNamed: name.
	newestMCPackage := aContext mcPackageRepo getNewestMCPackageWithPackageNamed: name.
	mcAuthors := aContext mcPackageRepo getAuthorAndCountsOfPackageNamed: name.
]

{ #category : #accessing }
SPPackageNameInfo >> versionCount [
	^ versionCount
]
