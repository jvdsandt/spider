Class {
	#name : #SPPackagesListPanel,
	#superclass : #SPListPanel,
	#instVars : [
		'classListPanel'
	],
	#category : #'Spider-Web-Core-Browser'
}

{ #category : #accessing }
SPPackagesListPanel >> classListPanel [
	^ classListPanel
]

{ #category : #accessing }
SPPackagesListPanel >> classListPanel: anObject [
	classListPanel := anObject
]

{ #category : #updating }
SPPackagesListPanel >> handleUpdate: script [

	self classListPanel updateOn: script
]

{ #category : #rendering }
SPPackagesListPanel >> renderContentOn: html [

	html select
		style: 'width: 100%;';
		size: 12;
		list: self browser packages;
		labels: [ :each | each name ];
		callback: [ :v | self browser selectedPackage: v ];
		onChange: (html jQuery ajax
			serializeThis ;
			script: [ :s | self handleUpdate: s ])
]
