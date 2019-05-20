Class {
	#name : #SPListPanel,
	#superclass : #SPAjaxComponent,
	#instVars : [
		'browser'
	],
	#category : #'Spider-Web-Core-Browser'
}

{ #category : #accessing }
SPListPanel >> browser [
	^ browser
]

{ #category : #accessing }
SPListPanel >> browser: anObject [
	browser := anObject
]
