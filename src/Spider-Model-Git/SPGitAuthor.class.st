Class {
	#name : #SPGitAuthor,
	#superclass : #Object,
	#instVars : [
		'name',
		'email'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #'instance creation' }
SPGitAuthor class >> name: aName email: anEmail [

	^ self new initWithName: aName email: anEmail
]

{ #category : #comparing }
SPGitAuthor >> = other [

	self == other
		ifTrue: [ ^ true ].
	self class = other class
		ifFalse: [ ^ false ].
	^ name = other name and: [ email = other email ]
]

{ #category : #accessing }
SPGitAuthor >> email [
	^ email
]

{ #category : #comparing }
SPGitAuthor >> hash [

	^ name hash
]

{ #category : #initialization }
SPGitAuthor >> initWithName: aName email: anEmail [

	name := aName.
	email := anEmail
]

{ #category : #accessing }
SPGitAuthor >> name [
	^ name
]

{ #category : #printing }
SPGitAuthor >> printOn: aStream [

	super printOn: aStream.
	
	aStream 
		nextPut: $(;
		nextPutAll: name;
		nextPutAll: ' <';
		nextPutAll: email;
		nextPutAll: '>)'
]
