Class {
	#name : #SPClassListPanel,
	#superclass : #SPListPanel,
	#instVars : [
		'categoryListPanel'
	],
	#category : #'Spider-Web-Browser'
}

{ #category : #accessing }
SPClassListPanel >> categoryListPanel [
	^ categoryListPanel
]

{ #category : #accessing }
SPClassListPanel >> categoryListPanel: anObject [
	categoryListPanel := anObject
]

{ #category : #rendering }
SPClassListPanel >> handleUpdate: script [

	self categoryListPanel updateOn: script
]

{ #category : #rendering }
SPClassListPanel >> renderContentOn: html [

	html select
		style: 'width: 100%;';
		size: 12;
		list: self browser classes;
		labels: [ :each | each name ];
		callback: [ :v | self browser selectedClass: v ];
		onChange: (html jQuery ajax
			serializeThis ;
			script: [ :s | self handleUpdate: s ])
]
