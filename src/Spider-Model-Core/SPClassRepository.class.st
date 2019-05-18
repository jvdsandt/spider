Class {
	#name : #SPClassRepository,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Core-Repos'
}

{ #category : #queries }
SPClassRepository >> getClassByHash: aBytes ifAbsent: aBlock [

	self subclassResponsibility
]

{ #category : #accessing }
SPClassRepository >> methodRepo [
	^ context methodRepo
]

{ #category : #'instance creation' }
SPClassRepository >> newClassBuilder [

	^ SPClassBuilder new
			setRepo: self;
			yourself
]

{ #category : #'instance creation' }
SPClassRepository >> newClassExtensionBuilder [

	^ SPClassExtensionBuilder new
			setRepo: self;
			yourself
]

{ #category : #initialization }
SPClassRepository >> setContext: aSpiderContext [

	context := aSpiderContext
]

{ #category : #stroring }
SPClassRepository >> storeClass: aSpiderClass [

	self subclassResponsibility
]

{ #category : #stroring }
SPClassRepository >> storeClassExtension: aClassExtension [

	self subclassResponsibility
]

{ #category : #accessing }
SPClassRepository >> transactionId [
	^ context currentTransactionId
]
