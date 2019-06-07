Class {
	#name : #SPiderRingBackend,
	#superclass : #RGReadOnlyBackend,
	#instVars : [
		'context'
	],
	#category : #'Spider-Model-Ring2'
}

{ #category : #'instance creation' }
SPiderRingBackend class >> for: anRGEnvironment context: spiderContext [

	^ (self for: anRGEnvironment) 
			setContext: spiderContext;
			yourself
]

{ #category : #accessing }
SPiderRingBackend >> context [
	^ context
]

{ #category : #initialization }
SPiderRingBackend >> setContext: spiderContext [

	context := spiderContext 
]
