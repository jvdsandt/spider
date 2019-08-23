Class {
	#name : #SPGlorp,
	#superclass : #Object,
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #testing }
SPGlorp class >> isAbstract [

	^ self == SPGlorp
]

{ #category : #accessing }
SPGlorp >> glorpSession [

	^ SPWebContext default glorpSession
]
