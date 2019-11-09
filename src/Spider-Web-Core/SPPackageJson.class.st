Class {
	#name : #SPPackageJson,
	#superclass : #SPJsonComponent,
	#instVars : [
		'package',
		'gitCommit',
		'mcPackage'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPPackageJson >> gitCommit [
	^ gitCommit
]

{ #category : #accessing }
SPPackageJson >> gitCommit: anObject [
	gitCommit := anObject
]

{ #category : #accessing }
SPPackageJson >> gitRootId: anId [

	self gitCommit: ((anId notNil and: [ package notNil ])
		ifTrue: [ self diffRepo getCommitOfPackage: package in: anId ]
		ifFalse: [ nil ])
]

{ #category : #accessing }
SPPackageJson >> mcPackage [
	^ mcPackage
]

{ #category : #accessing }
SPPackageJson >> mcPackage: anObject [
	mcPackage := anObject
]

{ #category : #accessing }
SPPackageJson >> package [
	^ package
]

{ #category : #accessing }
SPPackageJson >> package: anObject [
	package := anObject
]

{ #category : #rendering }
SPPackageJson >> renderClassRefs: aList on: json [

	json array: [ 
		aList do: [ :each |
			json object: [ 
				SPClassJson new
					packageToClassRef: each;
					renderClassSummaryOn: json ] ] ]
]

{ #category : #rendering }
SPPackageJson >> renderPackageOn: aRenderer [

	aRenderer object: [ 
		aRenderer 
			key: 'id' value: package id;
			key: 'name' value: package name;
			key: 'classes' value: [ self renderClassRefs: package classRefs on: aRenderer ];
			key: 'gitCommit' value: (gitCommit ifNotNil: [
				[ aRenderer object: [ self renderGitCommitSummary: gitCommit on: aRenderer ]	] ]);
			key: 'mcPackage' value: (mcPackage ifNotNil: [
				[ aRenderer object: [ self renderMCPackageSummary: mcPackage on: aRenderer ] ] ])
	]
]

{ #category : #rendering }
SPPackageJson >> renderPackageSummaryOn: aRenderer [

	aRenderer
		key: 'id' value: package id;
		key: 'name' value: package name
]
