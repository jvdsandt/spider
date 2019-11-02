Class {
	#name : #SPiderContext,
	#superclass : #Object,
	#instVars : [
		'glorpSession',
		'session',
		'currentTransaction',
		'repos'
	],
	#category : #'Spider-Model-Core-Context'
}

{ #category : #actions }
SPiderContext >> beginTransaction [ 

]

{ #category : #acessing }
SPiderContext >> classRepo [

	^ repos at: #classRepo ifAbsentPut: [ self createClassRepo ]
]

{ #category : #'initialize-release' }
SPiderContext >> close [

	repos := nil
]

{ #category : #actions }
SPiderContext >> commitTransaction [ 

]

{ #category : #running }
SPiderContext >> createClassRepo [ 

	^ SPClassImageRepository new
			setContext: self;
			yourself
]

{ #category : #actions }
SPiderContext >> createGlorpSession [

	^ nil
]

{ #category : #running }
SPiderContext >> createMethodRepo [ 

	^ SPMethodImageRepository new
			setContext: self;
			yourself
]

{ #category : #running }
SPiderContext >> createPackageRepo [ 

	^ SPPackageImageRepository new
			setContext: self;
			yourself
]

{ #category : #'initialize-release' }
SPiderContext >> createSession [

	^ SPGlorpSession id: 0 
			startDatetime: DateAndTime now
			image: Smalltalk image version
]

{ #category : #running }
SPiderContext >> createSessionRepo [ 

	^ SPSessionRepository new
			setContext: self;
			yourself
]

{ #category : #acessing }
SPiderContext >> currentTransaction [

	^ currentTransaction ifNil: [ currentTransaction := self newTransaction: nil ]
]

{ #category : #acessing }
SPiderContext >> currentTransactionId [

	^ self currentTransaction id
]

{ #category : #acessing }
SPiderContext >> diffRepo [

	^ repos at: #diffRepo ifAbsentPut: [ self createDiffRepo ]
]

{ #category : #actions }
SPiderContext >> doTransaction: aMessage with: aBlock [

	currentTransaction notNil
		ifTrue: [ self error: 'Nested transaction' ].
	[ 
		[
			self beginTransaction.
			currentTransaction := self newTransaction: aMessage.
			aBlock value.
			self commitTransaction 
		] on: Error do: [ :ex |
			self rollbackTransaction.
		self halt.
			self logError: ex ]
	] ensure: [ 	currentTransaction := nil ]
]

{ #category : #acessing }
SPiderContext >> glorpSession [

	^ glorpSession ifNil: [ glorpSession := self createGlorpSession ]
]

{ #category : #'initialize-release' }
SPiderContext >> initialize [

	super initialize.
	
	repos := Dictionary new.

]

{ #category : #testing }
SPiderContext >> isPostgresContext [

	^ false
]

{ #category : #testing }
SPiderContext >> isRDBContext [

	^ false
]

{ #category : #actions }
SPiderContext >> logError: anException [

	Transcript cr; show: 'ERROR: ', anException printString
]

{ #category : #acessing }
SPiderContext >> methodRepo [

	^ repos at: #methodRepo ifAbsentPut: [ self createMethodRepo ]
]

{ #category : #running }
SPiderContext >> newTransaction: aMessage [

	^ SPGlorpTransaction id: 0 
			session: session 
			startDatetime: DateAndTime now asUTC 
			message: aMessage
]

{ #category : #acessing }
SPiderContext >> packageRepo [

	^ repos at: #packageRepo ifAbsentPut: [ self createPackageRepo ]
]

{ #category : #actions }
SPiderContext >> rollbackTransaction [ 

]

{ #category : #acessing }
SPiderContext >> session [

	^ session ifNil: [ session := self createSession ]
]

{ #category : #acessing }
SPiderContext >> sessionRepo [

	^ repos at: #sessionRepo ifAbsentPut: [ self createSessionRepo ]
]
