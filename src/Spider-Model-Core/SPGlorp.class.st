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
SPGlorp >> currentContext [

	^ SPCurrentContext value
]

{ #category : #accessing }
SPGlorp >> glorpSession [

	^ self currentContext glorpSession
]
