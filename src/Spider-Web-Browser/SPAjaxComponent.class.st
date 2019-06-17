Class {
	#name : #SPAjaxComponent,
	#superclass : #SPComponent,
	#instVars : [
		'containerId'
	],
	#category : #'Spider-Web-Browser'
}

{ #category : #accessing }
SPAjaxComponent >> containerId [
	^ containerId
]

{ #category : #accessing }
SPAjaxComponent >> containerId: anObject [
	containerId := anObject
]

{ #category : #updating }
SPAjaxComponent >> updateOn: script [

	script << ((script jQuery id: self containerId) html: [ :h | self renderContentOn: h ])
]
