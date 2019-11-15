Class {
	#name : #SPClassJson,
	#superclass : #SPJsonComponent,
	#instVars : [
		'spiderClass',
		'category',
		'gitCommit',
		'mcPackage'
	],
	#category : #'Spider-Web-API'
}

{ #category : #accessing }
SPClassJson >> category [
	^ category
]

{ #category : #accessing }
SPClassJson >> category: anObject [
	category := anObject
]

{ #category : #accessing }
SPClassJson >> gitCommit [
	^ gitCommit
]

{ #category : #accessing }
SPClassJson >> gitCommit: anObject [
	gitCommit := anObject
]

{ #category : #accessing }
SPClassJson >> gitRootId: anId [

	self gitCommit: ((anId notNil and: [ spiderClass notNil ])
		ifTrue: [ self diffRepo getCommitOfClass: spiderClass in: anId ]
		ifFalse: [ nil ])
]

{ #category : #accessing }
SPClassJson >> mcPackage [
	^ mcPackage
]

{ #category : #accessing }
SPClassJson >> mcPackage: anObject [
	mcPackage := anObject
]

{ #category : #accessing }
SPClassJson >> packageToClassRef: aRef [

	self spiderClass: aRef spiderClass.
	self category: aRef category
]

{ #category : #rendering }
SPClassJson >> renderClassOn: aRenderer [

	aRenderer object: [ 
		self renderClassSummaryOn: aRenderer.
		aRenderer 
			key: 'comment' value: spiderClass comment.
		spiderClass isSpiderClassExtension
			ifFalse: [ 
				aRenderer
					key: 'definition' value: (spiderClass definitionIn: category);
					key: 'classDefinition' value: (spiderClass classDefinitionIn: category).
				self renderVariablesOf: spiderClass on: aRenderer ].
		aRenderer
			key: 'instanceMethods' value: [ self renderMethodRefs: spiderClass instanceMethodRefs on: aRenderer ]; 
			key: 'classMethods' value: [ self renderMethodRefs: spiderClass classMethodRefs on: aRenderer ].
		aRenderer 
			key: 'gitCommit' value: (gitCommit ifNotNil: [
				[ aRenderer object: [ self renderGitCommitSummary: gitCommit on: aRenderer ]	] ]);
			key: 'mcPackage' value: (mcPackage ifNotNil: [
				[ aRenderer object: [ self renderMCPackageSummary: mcPackage on: aRenderer ] ] ])
	]
]

{ #category : #rendering }
SPClassJson >> renderClassSummaryOn: json [

	json
		key: 'id' value: spiderClass id;
		key: 'name' value: spiderClass name;
		key: 'type' value: spiderClass typeName.
	spiderClass isSpiderClass 
		ifTrue: [ json key: 'superclass' value: spiderClass superclassName ].
	category notNil
		ifTrue: [ json key: 'category' value: category ]
]

{ #category : #rendering }
SPClassJson >> renderMethodRefs: aList on: aRenderer [

	aRenderer array: [ 
		aList do: [ :each |
			aRenderer object: [ 
				aRenderer 
					key: 'id' value: each method id;
					key: 'selector' value: each selector;
					key: 'category' value: each category ] ] ]
]

{ #category : #rendering }
SPClassJson >> renderVariablesOf: aClass on: json [

	json key: 'instanceVariables' value: aClass instanceVarNames.
	json key: 'classVariables' value: aClass classVarNames.
	aClass isSpiderTrait 
		ifFalse: [ 
			json key: 'classInstanceVariables' value: aClass classInstanceVarNames.
			json key: 'poolDictionaries' value: aClass poolDictionaryNames ]
]

{ #category : #accessing }
SPClassJson >> spiderClass [
	^ spiderClass
]

{ #category : #accessing }
SPClassJson >> spiderClass: anObject [
	spiderClass := anObject
]
