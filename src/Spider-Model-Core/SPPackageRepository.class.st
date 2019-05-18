Class {
	#name : #SPPackageRepository,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Core-Repos'
}

{ #category : #accessing }
SPPackageRepository >> classRepo [
	^ context classRepo
]

{ #category : #queries }
SPPackageRepository >> getPackageByHash: aBytes ifAbsent: aBlock [

	self subclassResponsibility
]

{ #category : #'instance creation' }
SPPackageRepository >> newBuilder [

	^ SPPackageBuilder new
			setRepo: self;
			yourself
]

{ #category : #initialization }
SPPackageRepository >> setContext: aSpiderContext [

	context := aSpiderContext
]

{ #category : #storing }
SPPackageRepository >> storePackage: aPackage [

	self subclassResponsibility
]

{ #category : #accessing }
SPPackageRepository >> transactionId [

	^ context currentTransactionId
]
