Class {
	#name : #SPGitSignature,
	#superclass : #Object,
	#instVars : [
		'name',
		'email',
		'datetime',
		'tzOffset'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #'instance creation' }
SPGitSignature class >> name: aName email: anEmail datetime: aDatetime offset: tzOffsetInMinutes [

	^ self new initWithName: aName email: anEmail datetime: aDatetime offset: tzOffsetInMinutes
]

{ #category : #accessing }
SPGitSignature >> datetime [
	^ datetime
]

{ #category : #accessing }
SPGitSignature >> email [
	^ email
]

{ #category : #initialization }
SPGitSignature >> initWithName: aName email: anEmail datetime: aDatetime offset: tzOffsetInMinutes [

	name := aName.
	email := anEmail.
	datetime := aDatetime.
	tzOffset := tzOffsetInMinutes
]

{ #category : #accessing }
SPGitSignature >> name [
	^ name
]

{ #category : #accessing }
SPGitSignature >> tzOffset [
	^ tzOffset
]
