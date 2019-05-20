Class {
	#name : #SPTransactionDetailsView,
	#superclass : #SPDetailsView,
	#instVars : [
		'transaction'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPTransactionDetailsView >> renderClassesOn: html [

	| list |
	
	list := self transaction classes ifEmpty: [ ^ self ].
	
	html unorderedList 
		with: [ 
			list do: [ :each |
				html listItem: each name ] ]
]

{ #category : #rendering }
SPTransactionDetailsView >> renderContentOn: html [

	self renderLabel: 'id' value: self transaction id on: html.
	self renderLabel: 'timestamp' value: self transaction startedAt on: html.
	self renderLabel: 'message' value: self transaction message on: html.
	
	self renderMCPackagesOn: html.
	self renderPackagesOn: html.
	self renderClassesOn: html.
]

{ #category : #rendering }
SPTransactionDetailsView >> renderMCPackagesOn: html [

	| list |
	
	list := self transaction mcPackages ifEmpty: [ ^ self ].
	
	html unorderedList 
		with: [ 
			list do: [ :each |
				html listItem: each fullName ] ]
]

{ #category : #rendering }
SPTransactionDetailsView >> renderPackagesOn: html [

	| list |
	
	list := self transaction packages ifEmpty: [ ^ self ].
	
	html unorderedList 
		with: [ 
			list do: [ :each |
				html listItem: each name ] ]
]

{ #category : #accessing }
SPTransactionDetailsView >> transaction [
	^ transaction
]

{ #category : #accessing }
SPTransactionDetailsView >> transaction: anObject [
	transaction := anObject
]
