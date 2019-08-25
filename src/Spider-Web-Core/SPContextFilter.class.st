Class {
	#name : #SPContextFilter,
	#superclass : #WARequestFilter,
	#category : #'Spider-Web-Core-Seaside'
}

{ #category : #processing }
SPContextFilter >> handleFiltered: aRequestContext [
	| context |
	context := SPWebContext default context.
	SPCurrentContext 
		value: context
		during: [ super handleFiltered: aRequestContext ]
]
