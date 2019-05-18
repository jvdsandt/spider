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

	GRPlatform current addToShutDownList: self
]

{ #category : #accessing }
SPLogger class >> shutDown [

	self defaultClear
]

{ #category : #accessing }
SPLogger class >> unload [
	GRPlatform current
		removeFromShutDownList: self
]

{ #category : #'as yet unclassified' }
SPLogger >> logInfo: aSource message: anObject [

	| str |
	
	str := self stream.
	str 
		nextPutAll: Time now print24;
		space;
		nextPutAll: aSource asString;
		nextPutAll: ' - ';
		nextPutAll: anObject asString;
		lf;
		flush
]

{ #category : #accessing }
SPLogger >> stream [

	^ stream
]

{ #category : #accessing }
SPLogger >> stream: aStream [

	stream := aStream
]
