Class {
	#name : #SPTranscriptLogger,
	#superclass : #SPLogger,
	#category : #'Spider-Model-Core-Util'
}

{ #category : #logging }
SPTranscriptLogger >> logLevel: aLevel source: aSource message: anObject [

	Transcript show: (String streamContents: [ :s |
		ZTimestamp now printOn: s format: #( $- $ $: nil ).
		s
			nextPutAll: ' ['; nextPutAll: aLevel; nextPutAll: '] ';
			nextPutAll: aSource asString;
			nextPutAll: ' - ';
			nextPutAll: anObject asString;
			nextPutAll: OSPlatform current lineEnding ])
]
