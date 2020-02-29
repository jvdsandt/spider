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
	oldestGitCommit := aContext diffRepo getOldestCommitWithClassNamed: name.
	newestGitCommit := aContext diffRepo getNewestCommitWithClassNamed: name.
	gitAuthors := (aContext diffRepo getAuthorAndCountsOfClassNamed: name)
		collect: [ :eachRow |
			Dictionary new
				at: 'author' put: eachRow first;
				at: 'count' put: eachRow last;
				yourself ].
	
	mcRepos := #(). "aContext mcPackageRepo getMCReposWithPackageNamed: name."
	oldestMCPackage := nil. "aContext mcPackageRepo getOldestMCPackageWithPackageNamed: name."
	newestMCPackage := nil. "aContext mcPackageRepo getNewestMCPackageWithPackageNamed: name."
	mcAuthors := #(). "aContext mcPackageRepo getAuthorAndCountsOfPackageNamed: name."
]
