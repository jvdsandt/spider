Class {
	#name : #SPMethodListPanel,
	#superclass : #SPListPanel,
	#instVars : [
		'sourcePanel'
	],
	#category : #'Spider-Web-Browser'
}

{ #category : #updating }
SPMethodListPanel >> handleUpdate: script [

	self sourcePanel updateOn: script
]

{ #category : #rendering }
SPMethodListPanel >> renderContentOn: html [

	html select
		style: 'width: 100%;';
		size: 12;
		list: self browser methods;
		labels: [ :each | each selector ];
		callback: [ :v | self browser selectedMethod: v ];
		onChange: (html jQuery ajax
			serializeThis ;
			script: [ :s | self handleUpdate: s ])
]

{ #category : #accessing }
SPMethodListPanel >> sourcePanel [
	^ sourcePanel
]

{ #category : #accessing }
SPMethodListPanel >> sourcePanel: anObject [
	sourcePanel := anObject
]

{ #category : #updating }
SPMethodListPanel >> updateOn: script [

	super updateOn: script.
	self handleUpdate: script
]
