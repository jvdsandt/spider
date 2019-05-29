Class {
	#name : #SPGitRepo,
	#superclass : #SPGlorpNode,
	#instVars : [
		'url',
		'branches'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #'instance creation' }
SPGitRepo class >> newFromUrl: anUrl [

	^ self new initFromUrl: anUrl
]

{ #category : #initialization }
SPGitRepo >> initFromUrl: anUrl [

	url := anUrl
]

{ #category : #accessing }
SPGitRepo >> url [

	^ url
]
