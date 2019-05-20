Class {
	#name : #SPZincServerAdaptor,
	#superclass : #ZnZincServerAdaptor,
	#instVars : [
		'apiDelegate'
	],
	#category : #'Spider-Web-Core-Zinc'
}

{ #category : #accessing }
SPZincServerAdaptor >> apiDelegate [
	^ apiDelegate
]

{ #category : #accessing }
SPZincServerAdaptor >> apiDelegate: anObject [
	apiDelegate := anObject
]

{ #category : #processing }
SPZincServerAdaptor >> process: aZnRequest [

	(apiDelegate notNil and: [ aZnRequest uri firstPathSegment = 'spider-api' ])
		ifTrue: [ ^ apiDelegate handleRequest: aZnRequest ].

	^ super process: aZnRequest
]
