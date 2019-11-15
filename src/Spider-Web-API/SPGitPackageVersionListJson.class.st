Class {
	#name : #SPGitPackageVersionListJson,
	#superclass : #SPJsonComponent,
	#instVars : [
		'name',
		'list'
	],
	#category : #'Spider-Web-API'
}

{ #category : #accessing }
SPGitPackageVersionListJson >> list [
	^ list
]

{ #category : #accessing }
SPGitPackageVersionListJson >> list: anObject [
	list := anObject
]

{ #category : #accessing }
SPGitPackageVersionListJson >> name [
	^ name
]

{ #category : #accessing }
SPGitPackageVersionListJson >> name: anObject [
	name := anObject
]

{ #category : #rendering }
SPGitPackageVersionListJson >> renderContentOn: json [

	json object: [ 
		json key: 'name' value: name.
		json key: 'list' value: [ 
			json array: [ 
				list do: [ :each |
					self renderDiffRecord: each on: json ] ] ] ]
]

{ #category : #rendering }
SPGitPackageVersionListJson >> renderDiffRecord: aDiffRecord on: json [

	json object: [ 
		json key: 'newId' value: (aDiffRecord newPackage ifNotNil: [ :p | p id ]).
		json key: 'oldId' value: (aDiffRecord oldPackage ifNotNil: [ :p | p id ]).
		json key: 'gitCommit' value: [ self renderGitCommitSummary: aDiffRecord commit on: json ] ]
]
