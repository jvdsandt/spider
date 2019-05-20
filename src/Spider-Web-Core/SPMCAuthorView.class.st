Class {
	#name : #SPMCAuthorView,
	#superclass : #SPDetailsView,
	#instVars : [
		'author'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPMCAuthorView >> author [
	^ author
]

{ #category : #accessing }
SPMCAuthorView >> author: anObject [
	author := anObject
]

{ #category : #rendering }
SPMCAuthorView >> renderContentOn: html [

	self renderLabel: 'Author' value: self author on: html.
	
	self renderRepositoriesOn: html.
	self renderPackagesOn: html.

]

{ #category : #rendering }
SPMCAuthorView >> renderPackagesOn: html [

	| list |
	
	list := self queries allMCPackagesWithAuthor: self author.
	
	html unorderedList
		with: [ 
			list do: [ :each |
				html listItem: each fullName ] ]
]

{ #category : #rendering }
SPMCAuthorView >> renderRepositoriesOn: html [

	| list |
	
	list := (self queries allMCRepositoriesWithAuthor: self author) ifEmpty: [ ^ self ].
	
	html heading
		level: 4;
		with: 'MC Repositories:'.
	
	html unorderedList
		with: [ 
			list do: [ :each |
				html listItem: each repoUrl ] ]
]
