Class {
	#name : #SPPackageDetailsView,
	#superclass : #SPDetailsView,
	#instVars : [
		'package'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPPackageDetailsView >> package [
	^ package
]

{ #category : #accessing }
SPPackageDetailsView >> package: anObject [
	package := anObject
]

{ #category : #rendering }
SPPackageDetailsView >> renderContentOn: html [

	self renderLabel: 'name' value: self package name on: html.
	
	html anchor 
		callback: [ self openBrowserOnPackage: self package ];
		with: 'Browse'

]
