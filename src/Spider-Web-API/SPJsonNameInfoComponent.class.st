Class {
	#name : #SPJsonNameInfoComponent,
	#superclass : #SPJsonComponent,
	#instVars : [
		'info'
	],
	#category : #'Spider-Web-API'
}

{ #category : #accessing }
SPJsonNameInfoComponent >> info [
	^ info
]

{ #category : #accessing }
SPJsonNameInfoComponent >> info: anObject [
	info := anObject
]

{ #category : #rendering }
SPJsonNameInfoComponent >> renderGitAuthorsOn: json [

	json array: [ 
		info gitAuthors do: [ :each | each jsonOn: json ] ]
]

{ #category : #rendering }
SPJsonNameInfoComponent >> renderGitReposOn: json [

	json array: [ 
		info gitRepos do: [ :each |
			self renderGitRepoSummary: each on: json ] ]
]

{ #category : #rendering }
SPJsonNameInfoComponent >> renderMCAuthorsOn: json [

	json array: [ 
		info mcAuthors do: [ :each | each jsonOn: json ] ]
]

{ #category : #rendering }
SPJsonNameInfoComponent >> renderMCReposOn: json [

	json array: [ 
		info mcRepos do: [ :each |
			self renderMCRepoSummary: each on: json ] ]
]
