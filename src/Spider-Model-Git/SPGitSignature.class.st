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

{ #category : #comparing }
SPGitSignature >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ datetime = other datetime and: [ 
			name = other name and: [ 
				email = other email and: [ 
					tzOffset = other tzOffset ] ] ]
]

{ #category : #accessing }
SPGitSignature >> datetime [
	^ datetime
]

{ #category : #accessing }
SPGitSignature >> email [
	^ email
]

{ #category : #comparing }
SPGitSignature >> hash [

	^ datetime hash
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
