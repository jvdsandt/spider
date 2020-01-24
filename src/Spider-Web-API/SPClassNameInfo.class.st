Class {
	#name : #SPClassNameInfo,
	#superclass : #SPNameInfo,
	#category : #'Spider-Web-API'
}

{ #category : #initialization }
SPClassNameInfo >> initWithName: aName gitRootId: anId [

	name := aName.
	gitRootId := anId
]

{ #category : #initialization }
SPClassNameInfo >> retrieveInfo: aContext [

	versionCount := aContext classRepo countOfClassesNamed: name.
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
