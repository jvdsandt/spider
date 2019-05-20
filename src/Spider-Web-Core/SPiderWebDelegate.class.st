Class {
	#name : #SPiderWebDelegate,
	#superclass : #Object,
	#instVars : [
		'resourceClasses'
	],
	#category : #'Spider-Web-Core-Zinc'
}

{ #category : #public }
SPiderWebDelegate >> handleRequest: request [

	| resourceClass |
	
	resourceClass := self resourceClassForPath: request uri pathSegments allButFirst asArray.
	(resourceClass isNil or: [ (resourceClass canHandle: request) not ])
		ifTrue: [ ^ ZnResponse notFound: 'No such resource' ]. 
	
	^ resourceClass new
			webContext: self webContext;
			request: request;
			execute
]

{ #category : #initialization }
SPiderWebDelegate >> initialize [

	super initialize.
	
	resourceClasses := SPiderWebResource allSubclasses 
		inject: Dictionary new
		into: [ :dict :each | dict at: each path put: each; yourself ].
]

{ #category : #accessing }
SPiderWebDelegate >> resourceClassForPath: anArray [

	anArray isEmpty
		ifTrue: [ ^ nil ].
		
	^ resourceClasses at: anArray ifAbsent: [ self resourceClassForPath: anArray allButLast ]
]

{ #category : #accessing }
SPiderWebDelegate >> webContext [

	^ SPWebContext default
]
