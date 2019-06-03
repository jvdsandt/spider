Class {
	#name : #SPLogger,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#classVars : [
		'Default'
	],
	#category : #'Spider-Model-Core-Util'
}

{ #category : #current }
SPLogger class >> createDefault [

	| fname stream |
	
	fname := '/tmp/spider-', (Date today printFormat: #( 3 2 1 $- 1 1 2 )), '.log'.
	stream := fname asFileReference writeStream.
	stream setToEnd.

	^ self new
			stream: stream;
			yourself
]

{ #category : #accessing }
SPLogger class >> default [

	^ Default ifNil: [ Default := self createDefault ]
]

{ #category : #accessing }
SPLogger class >> default: aLogger [

	Default := aLogger
]

{ #category : #accessing }
SPLogger class >> defaultClear [

	Default := nil
]

{ #category : #accessing }
SPLogger class >> initialize [

	SessionManager default registerToolClassNamed: self name
]

{ #category : #accessing }
SPLogger class >> shutDown [

	self defaultClear
]

{ #category : #accessing }
SPLogger class >> unload [

	SessionManager default unregisterClassNamed: self name
]

{ #category : #logging }
SPLogger >> logDebug: aSource message: anObject [

	self logLevel: 'DEBUG' source: aSource message: anObject
]

{ #category : #logging }
SPLogger >> logError: aSource message: anObject [

	self logLevel: 'ERROR' source: aSource message: anObject
]

{ #category : #logging }
SPLogger >> logInfo: aSource message: anObject [

	self logLevel: 'INFO' source: aSource message: anObject
]

{ #category : #logging }
SPLogger >> logLevel: aLevel source: aSource message: anObject [

	| str |
	
	str := self stream.
	str 
		nextPutAll: Time now print24;
		nextPutAll: ' ['; nextPutAll: aLevel; nextPutAll: ' ]';
		nextPutAll: aSource asString;
		nextPutAll: ' - ';
		nextPutAll: anObject asString;
		lf;
		flush
]

{ #category : #logging }
SPLogger >> logWarn: aSource message: anObject [

	self logLevel: 'WARN' source: aSource message: anObject
]

{ #category : #accessing }
SPLogger >> stream [

	^ stream
]

{ #category : #accessing }
SPLogger >> stream: aStream [

	stream := aStream
]
