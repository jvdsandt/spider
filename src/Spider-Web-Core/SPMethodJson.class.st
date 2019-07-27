Class {
	#name : #SPMethodJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPMethodJson >> renderMethod: aMethod on: json [

	json object: [ 
		json 
			key: 'id' value: aMethod id;
			key: 'selector' value: aMethod selector;
			key: 'source' value: aMethod source ]
]
