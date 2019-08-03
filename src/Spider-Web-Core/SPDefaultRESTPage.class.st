Class {
	#name : #SPDefaultRESTPage,
	#superclass : #SPPage,
	#instVars : [
		'contentPanel'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPDefaultRESTPage >> contentPanel [
	^ contentPanel
]

{ #category : #accessing }
SPDefaultRESTPage >> contentPanel: anObject [
	contentPanel := anObject
]

{ #category : #rendering }
SPDefaultRESTPage >> renderContentOn: html [

	html div
		class: 'container';
		with: [ html render: self contentPanel ]
]
