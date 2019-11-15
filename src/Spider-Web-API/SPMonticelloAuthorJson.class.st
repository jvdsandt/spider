Class {
	#name : #SPMonticelloAuthorJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-API'
}

{ #category : #rendering }
SPMonticelloAuthorJson >> renderList: aList more: hasMore on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'list' value: [ 
			aRenderer array: (aList collect: [ :each | each ]).
		aRenderer key: 'hasMore' value: hasMore ] ]
]
