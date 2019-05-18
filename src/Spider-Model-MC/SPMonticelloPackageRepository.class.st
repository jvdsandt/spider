Class {
	#name : #SPMonticelloPackageRepository,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-MC-Repos'
}

{ #category : #'instance creation' }
SPMonticelloPackageRepository >> newBuilder [

	^ SPMonticelloPackageBuilder new
			setRepo: self;
			yourself
]

{ #category : #accessing }
SPMonticelloPackageRepository >> packageRepo [
	^ context packageRepo
]

{ #category : #initialization }
SPMonticelloPackageRepository >> setContext: aSpiderContext [

	context := aSpiderContext
]

{ #category : #accessing }
SPMonticelloPackageRepository >> transactionId [

	^ context currentTransactionId
]
