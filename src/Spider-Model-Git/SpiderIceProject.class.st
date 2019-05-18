Class {
	#name : #SpiderIceProject,
	#superclass : #IceInvalidProject,
	#instVars : [
		'sourceDirectory',
		'writerClass'
	],
	#category : #'Spider-Model-Git-Ice'
}

{ #category : #accessing }
SpiderIceProject >> sourceDirectory [
	^ sourceDirectory ifNil: [ super sourceDirectory ]
]

{ #category : #accessing }
SpiderIceProject >> sourceDirectory: anObject [
	sourceDirectory := anObject
]

{ #category : #accessing }
SpiderIceProject >> writerClass [
	^ writerClass ifNil: [ super writerClass ]
]

{ #category : #accessing }
SpiderIceProject >> writerClass: anObject [
	writerClass := anObject
]
