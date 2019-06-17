Class {
	#name : #SPPackagesRestfulHandler,
	#superclass : #SPRestfulHandler,
	#category : #'Spider-Web-Core'
}

{ #category : #'tools registry' }
SPPackagesRestfulHandler class >> register [
	WAAdmin register: self at: 'packages'
]

{ #category : #'as yet unclassified' }
SPPackagesRestfulHandler >> getNamesList [
	<get>
	<path: '/_names'>
	<produces: 'text/html'>
	
	| packages |
	
	packages := self packageRepo getAllPackageNames.
	
	^ self renderHtml: (SPPackageNamesListView new
		list: packages;
		yourself)
]
