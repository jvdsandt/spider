Class {
	#name : #SPSourcePanel,
	#superclass : #SPAjaxComponent,
	#instVars : [
		'browser'
	],
	#category : #'Spider-Web-Core-Browser'
}

{ #category : #accessing }
SPSourcePanel >> browser [
	^ browser
]

{ #category : #accessing }
SPSourcePanel >> browser: anObject [
	browser := anObject
]

{ #category : #rendering }
SPSourcePanel >> renderContentOn: html [

	html preformatted
		style: 'tab-size:2; min-height: 120px;';
		with: self browser source
]
