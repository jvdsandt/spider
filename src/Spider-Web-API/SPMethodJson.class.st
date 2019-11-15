Class {
	#name : #SPMethodJson,
	#superclass : #SPJsonComponent,
	#instVars : [
		'method',
		'gitCommit',
		'mcPackage',
		'category'
	],
	#category : #'Spider-Web-API'
}

{ #category : #accessing }
SPMethodJson >> category [
	^ category
]

{ #category : #accessing }
SPMethodJson >> category: anObject [
	category := anObject
]

{ #category : #accessing }
SPMethodJson >> gitCommit [
	^ gitCommit
]

{ #category : #accessing }
SPMethodJson >> gitCommit: anObject [
	gitCommit := anObject
]

{ #category : #accessing }
SPMethodJson >> gitRootId: anId className: aClassName meta: isMeta [

	self gitCommit: ((anId notNil and: [ aClassName notNil and: [ isMeta notNil and: [ method notNil ] ] ])
		ifTrue: [ self diffRepo getCommitOfMethod: method className: aClassName meta: isMeta in: anId ]
		ifFalse: [ nil ])
]

{ #category : #accessing }
SPMethodJson >> mcPackage [
	^ mcPackage
]

{ #category : #accessing }
SPMethodJson >> mcPackage: anObject [
	mcPackage := anObject
]

{ #category : #accessing }
SPMethodJson >> method [
	^ method
]

{ #category : #accessing }
SPMethodJson >> method: anObject [
	method := anObject
]

{ #category : #accessing }
SPMethodJson >> methodRef: aRef [

	self method: aRef method.
	self category: aRef category
]

{ #category : #rendering }
SPMethodJson >> renderMethodOn: json [

	json object: [ 
		json 
			key: 'id' value: method id;
			key: 'selector' value: method selector.
		category
			ifNotNil: [ json key: 'category' value: category ].
		json
			key: 'source' value: method source;
			key: 'gitCommit' value: (gitCommit ifNotNil: [
				[ json object: [ self renderGitCommitSummary: gitCommit on: json ] ] ])
	]
]

{ #category : #rendering }
SPMethodJson >> renderMethodSummaryOn: json [

	json object: [ 
		json 
			key: 'id' value: method id;
			key: 'selector' value: method selector.
		category
			ifNotNil: [ json key: 'category' value: category ] ]
]
