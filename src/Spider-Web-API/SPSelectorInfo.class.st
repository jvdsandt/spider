Class {
	#name : #SPSelectorInfo,
	#superclass : #SPNameInfo,
	#category : #'Spider-Web-API'
}

{ #category : #initialization }
SPSelectorInfo >> retrieveInfo: aContext [

	versionCount := aContext methodRepo countImplementorsOf: name.
	versionCount = 0
		ifTrue: [ ^ self ].

	gitRepos := #().
	oldestGitCommit := aContext diffRepo getOldestCommitWithSelector: name.
	newestGitCommit := aContext diffRepo getNewestCommitWithSelector: name.
	gitAuthors := (aContext diffRepo getAuthorAndCountsOfSelector: name)
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
