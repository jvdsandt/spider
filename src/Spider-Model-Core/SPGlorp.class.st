Class {
	#name : #SPGlorp,
	#superclass : #Object,
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #accessing }
SPGlorp >> glorpSession [

	^ SPWebContext default glorpSession
]
