Class {
	#name : #SPPackageNameInfo,
	#superclass : #SPNameInfo,
	#category : #'Spider-Web-API'
}

{ #category : #initialization }
SPPackageNameInfo >> initWithName: aName gitRootId: anId [

	name := aName.
	gitRootId := anId
]

{ #category : #initialization }
SPPackageNameInfo >> retrieveInfo: aContext [

	versionCount := aContext gitRepo packageRepo countOfPackagesNamed: name.
	versionCount = 0
		ifTrue: [ ^ self ].

	gitRepos := aContext gitRepo getReposWithPackageNamed: name.
	oldestGitCommit := aContext gitRepo getOldestCommitWithPackageNamed: name.
	newestGitCommit := aContext gitRepo getNewestCommitWithPackageNamed: name.
	gitAuthors := (aContext diffRepo getAuthorAndCountsOfPackageNamed: name)
		collect: [ :eachRow |
			Dictionary new
				at: 'author' put: eachRow first;
				at: 'count' put: eachRow last;
				yourself ].
	
	mcRepos := aContext mcPackageRepo getMCReposWithPackageNamed: name.
	oldestMCPackage := aContext mcPackageRepo getOldestMCPackageWithPackageNamed: name.
	newestMCPackage := aContext mcPackageRepo getNewestMCPackageWithPackageNamed: name.
	mcAuthors := (aContext mcPackageRepo getAuthorAndCountsOfPackageNamed: name)
		collect: [ :eachRow |
			Dictionary new
				at: 'author' put: eachRow first;
				at: 'count' put: eachRow last;
				yourself ]
]
