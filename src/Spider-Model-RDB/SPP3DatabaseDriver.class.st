Class {
	#name : #SPP3DatabaseDriver,
	#superclass : #P3DatabaseDriver,
	#instVars : [
		'lastLogin',
		'usedFlag',
		'mutex'
	],
	#category : #'Spider-Model-RDB-Util'
}

{ #category : #executing }
SPP3DatabaseDriver >> basicExecuteSQLString: aString [

	self isConnected 
		ifFalse: [ self reconnect ].
	usedFlag := true.
	^ super basicExecuteSQLString: aString
]

{ #category : #accessing }
SPP3DatabaseDriver >> connect: aLogin [
	lastLogin := aLogin.
	self privConnect: aLogin.
	self initWatchProcess
]

{ #category : #initialization }
SPP3DatabaseDriver >> initWatchProcess [

	| watchBlock |
	
	watchBlock := [ 
		[ self isConnected ] whileTrue: [ 
			(Delay forSeconds: 300) wait.
			usedFlag
				ifTrue: [ usedFlag := false ]
				ifFalse: [ self privDisconnectIfUnused ] ] ].
	watchBlock forkAt: Processor systemBackgroundPriority named: 'db connection watcher'
]

{ #category : #initialization }
SPP3DatabaseDriver >> initialize [

	super initialize.
	mutex := Semaphore forMutualExclusion.

]

{ #category : #login }
SPP3DatabaseDriver >> logout [
	self privDisconnect
]

{ #category : #internal }
SPP3DatabaseDriver >> privConnect: aLogin [

	mutex critical: [ 
		self isConnected 
			ifFalse: [ 
				connection := self connectionClass new.
				connection 
					host: aLogin host;
					port: aLogin port asInteger;
					timeout: 60;
					database: aLogin databaseName;
					user: aLogin username;
					password: aLogin password.
				self logInfo: 'Conecting ...'.
				connection connect.
				self logInfo: 'Connected'.
				usedFlag := true ] ]
]

{ #category : #internal }
SPP3DatabaseDriver >> privDisconnect [
	connection ifNotNil: [ 
		connection close.
		connection := nil ]
]

{ #category : #internal }
SPP3DatabaseDriver >> privDisconnectIfUnused [

	mutex critical: [ 
		(self isConnected and: [ usedFlag not ])
			ifTrue: [ 
				self privDisconnect.
				self logInfo: 'Disconnected' ] ]
]

{ #category : #accessing }
SPP3DatabaseDriver >> reconnect [
	self privConnect: lastLogin
]
