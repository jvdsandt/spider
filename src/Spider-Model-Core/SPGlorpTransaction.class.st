Class {
	#name : #SPGlorpTransaction,
	#superclass : #SPGlorpNode,
	#instVars : [
		'session',
		'startedAt',
		'message'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPGlorpTransaction class >> id: anId session: aSession startDatetime: aDatetime message: aString [

	^ self new initWithId: anId session: aSession startDatetime: aDatetime message: aString
]

{ #category : #queries }
SPGlorpTransaction >> classes [

	| query |
	
	query := Query read: SPGlorpClass where: [ :each | each transaction = self ].
	query orderBy: [ :each | each name ].
	
	^ self glorpSession execute: query
]

{ #category : #initialization }
SPGlorpTransaction >> initWithId: anId session: aSession startDatetime: aDatetime message: aString [

	id := anId.
	session := aSession.
	startedAt := aDatetime.
	message := aString
]

{ #category : #queries }
SPGlorpTransaction >> mcPackages [

	| query |
	
	query := Query read: SPGlorpMonticelloPackage where: [ :each | each transaction = self ].
	
	^ self glorpSession execute: query
]

{ #category : #accessing }
SPGlorpTransaction >> message [
	^ message
]

{ #category : #accessing }
SPGlorpTransaction >> message: anObject [
	message := anObject
]

{ #category : #queries }
SPGlorpTransaction >> methods [

	| query |
	
	query := Query read: SPGlorpMethod where: [ :each | each transaction = self ].
	
	^ self glorpSession execute: query
]

{ #category : #queries }
SPGlorpTransaction >> packages [

	| query |
	
	query := Query read: SPGlorpPackage where: [ :each | each transaction = self ].
	
	^ self glorpSession execute: query
]

{ #category : #accessing }
SPGlorpTransaction >> session [
	^ session
]

{ #category : #accessing }
SPGlorpTransaction >> session: anObject [
	session := anObject
]

{ #category : #accessing }
SPGlorpTransaction >> startedAt [
	^ startedAt
]

{ #category : #accessing }
SPGlorpTransaction >> startedAt: anObject [
	startedAt := anObject
]
