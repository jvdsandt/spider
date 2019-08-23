Class {
	#name : #SPPathRoute,
	#superclass : #WAComplexRoute,
	#category : #'Spider-Web-Core-Seaside'
}

{ #category : #'instance creation' }
SPPathRoute class >> get: aString selector: aSymbol [
	^ self
		method: 'GET'
		selector: aSymbol
		pattern: aString
]

{ #category : #testing }
SPPathRoute >> matchesParameters: aDictionary [
	"Ignore parameters"
	^ true
]
