Class {
	#name : #SPNameInfo,
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
SPNameInfo >> gitAuthorNames [

	^ (self gitAuthors collect: [ :each | each name ]) asSet sorted
]

{ #category : #accessing }
SPNameInfo >> gitAuthors [
	^ gitAuthors
]

{ #category : #accessing }
SPNameInfo >> gitRepos [
	^ gitRepos
]

{ #category : #accessing }
SPNameInfo >> gitRootId [
	^ gitRootId
]

{ #category : #accessing }
SPNameInfo >> mcAuthors [
	^ mcAuthors
]

{ #category : #accessing }
SPNameInfo >> mcRepos [
	^ mcRepos
]

{ #category : #accessing }
SPNameInfo >> name [
	^ name
]

{ #category : #accessing }
SPNameInfo >> newestGitCommit [
	^ newestGitCommit
]

{ #category : #accessing }
SPNameInfo >> newestMCPackage [
	^ newestMCPackage
]

{ #category : #accessing }
SPNameInfo >> oldestGitCommit [
	^ oldestGitCommit
]

{ #category : #accessing }
SPNameInfo >> oldestMCPackage [
	^ oldestMCPackage
]

{ #category : #accessing }
SPNameInfo >> versionCount [
	^ versionCount
]
