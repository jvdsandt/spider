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

{ #category : #accessing }
SPGitAuthor >> email [
	^ email
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
