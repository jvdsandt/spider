Class {
	#name : #SPListPanel,
	#superclass : #SPAjaxComponent,
	#instVars : [
		'browser'
	],
	#category : #'Spider-Web-Browser'
}

{ #category : #accessing }
SPListPanel >> browser [
	^ browser
]

{ #category : #accessing }
SPListPanel >> browser: anObject [
	browser := anObject
]
