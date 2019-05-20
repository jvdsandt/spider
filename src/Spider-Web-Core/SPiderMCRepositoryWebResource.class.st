Class {
	#name : #SPiderMCRepositoryWebResource,
	#superclass : #SPiderWebResource,
	#category : #'Spider-Web-Core-API'
}

{ #category : #accessing }
SPiderMCRepositoryWebResource class >> path [

	^ #( 'mc_repo' )
]

{ #category : #accessing }
SPiderMCRepositoryWebResource >> execute [ 

	| result |
	
	result := self list.
	
	^ ZnResponse ok: (ZnEntity json: result)
]

{ #category : #accessing }
SPiderMCRepositoryWebResource >> list [

	| list |
	
	list := self queries allMCRepositories: self paramLimit after: self paramAfterKey.
	
	^ self render: [ :json | self renderList: list on: json ]
]

{ #category : #accessing }
SPiderMCRepositoryWebResource >> renderItem: anItem on: json [

	json object: [ 
		json key: 'id' value: anItem id.
		json key: 'repoUrl' value: anItem repoUrl ]
]

{ #category : #accessing }
SPiderMCRepositoryWebResource >> renderList: aList on: json [

	json array: [ 
		aList do: [ :each |
			self renderItem: each on: json ] ]
]
