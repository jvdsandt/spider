Class {
	#name : #SPMethodRepository,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Core-Repos'
}

{ #category : #queries }
SPMethodRepository >> allSelectors [ 

	self subclassResponsibility
]

{ #category : #queries }
SPMethodRepository >> allVariables [

	self subclassResponsibility
]

{ #category : #'instance creation' }
SPMethodRepository >> newBuilder [

	^ SPMethodBuilder new
			setRepo: self;
			yourself
]

{ #category : #initialization }
SPMethodRepository >> setContext: aSpiderContext [

	context := aSpiderContext
]

{ #category : #storing }
SPMethodRepository >> storeMethod: aMethod [

	self subclassResponsibility
]

{ #category : #accessing }
SPMethodRepository >> transactionId [

	^ context currentTransactionId
]
