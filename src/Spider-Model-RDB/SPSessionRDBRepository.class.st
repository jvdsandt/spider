Class {
	#name : #SPSessionRDBRepository,
	#superclass : #SPSessionRepository,
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #'accessing - queries' }
SPSessionRDBRepository >> insertSessionQuery [

	self subclassResponsibility
]

{ #category : #'accessing - queries' }
SPSessionRDBRepository >> insertTransactionQuery [

	self subclassResponsibility
]

{ #category : #actions }
SPSessionRDBRepository >> newSession [

	| startDatetime imageVersion sessionId |
	
	startDatetime := DateAndTime now asUTC.
	imageVersion := Smalltalk image version.
	
	sessionId := self insertSessionQuery getOne: (Array with: startDatetime with: imageVersion).
	
	^SPGlorpSession id: sessionId startDatetime: startDatetime image: imageVersion
]

{ #category : #actions }
SPSessionRDBRepository >> newTransaction: aMessage with: aSession [

	| startDatetime transactionId |
	
	startDatetime := DateAndTime now asUTC.
	transactionId := self insertTransactionQuery getOne: (Array with: aSession id with: startDatetime with: aMessage).
	
	^SPGlorpTransaction id: transactionId session: aSession startDatetime: startDatetime message: aMessage
]
