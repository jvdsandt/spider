Class {
	#name : #SPGlorpSession,
	#superclass : #SPGlorpNode,
	#instVars : [
		'startedAt',
		'imageVersion'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPGlorpSession class >> id: anId startDatetime: aDatetime image: imageVersion [

	^ self new initWithId: anId startDatetime: aDatetime image: imageVersion
]

{ #category : #accessing }
SPGlorpSession >> imageVersion [
	^ imageVersion
]

{ #category : #accessing }
SPGlorpSession >> imageVersion: anObject [
	imageVersion := anObject
]

{ #category : #initialization }
SPGlorpSession >> initWithId: anId startDatetime: aDatetime image: aImageVersion [ 
	
	id := anId.
	startedAt := aDatetime.
	imageVersion := aImageVersion
]

{ #category : #accessing }
SPGlorpSession >> startedAt [
	^ startedAt
]

{ #category : #accessing }
SPGlorpSession >> startedAt: anObject [
	startedAt := anObject
]
