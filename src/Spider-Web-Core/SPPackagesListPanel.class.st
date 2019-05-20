Class {
	#name : #SPPackagesListPanel,
	#superclass : #SPListPanel,
	#instVars : [
		'pacakes'
	],
	#category : #'Spider-Web-Core-Browser'
}

{ #category : #rendering }
SPPackagesListPanel >> renderContentOn: html [

	html select
		size: 12;
		list: self browser packages
]
