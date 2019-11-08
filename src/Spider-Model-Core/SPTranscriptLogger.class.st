Class {
	#name : #SPTranscriptLogger,
	#superclass : #SPLogger,
	#category : #'Spider-Model-Core-Util'
}

{ #category : #logging }
SPTranscriptLogger >> logLevel: aLevel source: aSource message: anObject [

	Transcript crShow: (String streamContents: [ :s |
		s
			nextPutAll: Time now print24;
			nextPutAll: ' ['; nextPutAll: aLevel; nextPutAll: '] ';
			nextPutAll: aSource asString;
			nextPutAll: ' - ';
			nextPutAll: anObject asString ])
]
