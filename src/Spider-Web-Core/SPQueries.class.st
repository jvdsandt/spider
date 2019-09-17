Class {
	#name : #SPQueries,
	#superclass : #Object,
	#instVars : [
		'context',
		'glorpSession'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #'queries-mc-packages' }
SPQueries >> allMCAuthorsByName [

	| query |
	
	query := (Query read: SPMonticelloPackage)
		retrieve: [ :each | each author ];
		retrieve: [ :each | each datetime min ];
		retrieve: [ :each | each datetime max ];
		retrieve: [ :each | each countStar ];
		groupBy: [ :each | each author ];
		orderBy: [ :each | each author ];
		yourself.
	
	^ glorpSession execute: query
]

{ #category : #'queries-mc-packages' }
SPQueries >> allMCPackageNamesByCountDesc [

	| query |
	
	query := (Query read: SPMonticelloPackage)
		retrieve: [ :each | each name ];
		retrieve: [ :each | each datetime min ];
		retrieve: [ :each | each datetime max ];
		retrieve: [ :each | each countStar ];
		groupBy: [ :each | each name ];
		orderBy: [ :each | each countStar descending ];
		yourself.
	
	^ glorpSession execute: query
]

{ #category : #'queries-mc-packages' }
SPQueries >> allMCPackageNamesByDatetimeMaxDesc [

	| query |
	
	query := (Query read: SPMonticelloPackage)
		retrieve: [ :each | each name ];
		retrieve: [ :each | each datetime min ];
		retrieve: [ :each | each datetime max ];
		retrieve: [ :each | each countStar ];
		groupBy: [ :each | each name ];
		orderBy: [ :each | each datetime max descending ];
		yourself.
	
	^ glorpSession execute: query
]

{ #category : #'queries-mc-packages' }
SPQueries >> allMCPackageNamesByDatetimeMin [

	| query |
	
	query := (Query read: SPMonticelloPackage)
		retrieve: [ :each | each name ];
		retrieve: [ :each | each datetime min ];
		retrieve: [ :each | each datetime max ];
		retrieve: [ :each | each countStar ];
		groupBy: [ :each | each name ];
		orderBy: [ :each | each datetime min ];
		yourself.
	
	^ glorpSession execute: query
]

{ #category : #'queries-mc-packages' }
SPQueries >> allMCPackageNamesByName [

	| query |
	
	query := (Query read: SPMonticelloPackage)
		retrieve: [ :each | each name ];
		retrieve: [ :each | each datetime min ];
		retrieve: [ :each | each datetime max ];
		retrieve: [ :each | each countStar ];
		groupBy: [ :each | each name ];
		orderBy: [ :each | each name ];
		yourself.
	
	^ glorpSession execute: query
]

{ #category : #'queries-mc-packages' }
SPQueries >> allMCPackagesWithAuthor: anAuthor [

	| query |
	
	query := (Query read: SPMonticelloPackage where: [ :e | e author = anAuthor ])
		orderBy: [ :each | each name descending ];
		orderBy: [ :each | each datetime descending ];
		yourself.
	
	^ glorpSession execute: query
]

{ #category : #'queries-mc-repos' }
SPQueries >> allMCRepositories [

	| query |
	
	query := (Query read: SPMonticelloRepository)
		orderBy: [ :each | each repoUrl ];
		yourself.
	
	^ glorpSession execute: query
]

{ #category : #'queries-mc-repos' }
SPQueries >> allMCRepositories: maxResults after: aKey [

	| query |
	
	query := Query read: SPMonticelloRepository.
	aKey notNil
		ifTrue: [ query where: [ :e | e repoUrl > aKey ] ].
	query orderBy: [ :each | each repoUrl ].
	query limit: maxResults.
	
	^ glorpSession execute: query
]

{ #category : #'queries-mc-repos' }
SPQueries >> allMCRepositoriesWithAuthor: anAuthor [

	| query |
	
	query := (Query read: SPMonticelloRepository where: [ :each | each mcPackageRefs anySatisfy: [ :p | p mcPackage author = anAuthor ] ])
		orderBy: [ :each | each repoUrl ];
		yourself.
	
	^ glorpSession execute: query
]

{ #category : #accessing }
SPQueries >> context [
	^ context
]

{ #category : #accessing }
SPQueries >> context: anObject [
	context := anObject
]

{ #category : #accessing }
SPQueries >> glorpSession [
	^ glorpSession
]

{ #category : #accessing }
SPQueries >> glorpSession: anObject [
	glorpSession := anObject
]

{ #category : #'queries-transactions' }
SPQueries >> latestTransactions: aLimit [

	| query |
	
	query := (Query read: SPGlorpTransaction)
		orderBy: [ :each | each startedAt descending ];
		limit: aLimit;
		yourself.
	
	^ glorpSession execute: query
]
