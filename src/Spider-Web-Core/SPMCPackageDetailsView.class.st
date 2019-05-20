Class {
	#name : #SPMCPackageDetailsView,
	#superclass : #SPDetailsView,
	#instVars : [
		'mcPackage'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPMCPackageDetailsView >> mcPackage [
	^ mcPackage
]

{ #category : #accessing }
SPMCPackageDetailsView >> mcPackage: anObject [
	mcPackage := anObject
]

{ #category : #accessing }
SPMCPackageDetailsView >> renderAncestorsOn: html [

	html paragraph: [ 
		html text: 'Ancestors: '.
		self mcPackage ancestors
			do: [ :each | 
				html anchor
					callback: [ self openMCPackage: each ];
					with: each fullName ]
			separatedBy: [ html text: ', ' ] ]
]

{ #category : #accessing }
SPMCPackageDetailsView >> renderAuthorOn: html [

	html paragraph: [ 
		html text: 'Author: '.
		html anchor
			callback: [ self openMCAuthor: self mcPackage author ];
			with:self mcPackage author ]
]

{ #category : #accessing }
SPMCPackageDetailsView >> renderContentOn: html [

	self renderTitle: 'Monticello Package details' on: html. 

	self renderLabel: 'Name' value: self mcPackage fullName on: html.
	self renderAuthorOn: html.
	self renderLabel: 'Time' value: self mcPackage datetime on: html.
	self renderLabel: 'UUID' value: self mcPackage uuid on: html. 
	self renderAncestorsOn: html.
	self renderDescendantsOn: html.

	html paragraph: [ 
		html text: 'Message: '.
		html preformatted
			style: 'white-space: pre-wrap;';
			with: self mcPackage message ]
]

{ #category : #accessing }
SPMCPackageDetailsView >> renderDescendantsOn: html [

	html paragraph: [ 
		html text: 'Descendants: '.
		self mcPackage descendants
			do: [ :each | 
				html anchor
					callback: [ self openMCPackage: each ];
					with: each fullName ]
			separatedBy: [ html text: ', ' ] ]
]
