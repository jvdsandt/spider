Class {
	#name : #SPMethodJson,
	#superclass : #SPJsonComponent,
	#instVars : [
		'method',
		'gitCommit',
		'mcPackage'
	],
	#category : #'Spider-Web-Core'
}

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

{ #category : #rendering }
SPMethodJson >> renderMethod: aMethod on: json [

	json object: [ 
		json 
			key: 'id' value: aMethod id;
			key: 'selector' value: aMethod selector;
			key: 'source' value: aMethod source ]
]

{ #category : #rendering }
SPMethodJson >> renderMethodSummary: aMethod in: aCategory on: json [

	json object: [ 
		json 
			key: 'id' value: aMethod id;
			key: 'selector' value: aMethod selector;
			key: 'category' value: aCategory ]
]

{ #category : #rendering }
SPMethodJson >> renderMethodSummary: aMethod on: json [

	json object: [ 
		json 
			key: 'id' value: aMethod id;
			key: 'selector' value: aMethod selector ]
]
