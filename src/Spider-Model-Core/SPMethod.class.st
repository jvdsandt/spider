Class {
	#name : #SPMethod,
	#superclass : #SPGlorpNode,
	#instVars : [
		'selector',
		'source',
		'sourceHash',
		'selectorRefs',
		'variableRefs'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #constants }
SPMethod class >> flagPragma [

	^ 2r10000000
]

{ #category : #constants }
SPMethod class >> flagSelfSend [

	^ 2r00000010
]

{ #category : #'instance creation' }
SPMethod class >> selector: aSelector source: aSource hash: aSourceHash selectorRefs: selRefs variableRefs: varRefs [ 

	^ self new initSelector: aSelector 
			source: aSource 
			hash: aSourceHash 
			selectorRefs: selRefs 
			variableRefs: varRefs 
]

{ #category : #comparing }
SPMethod >> <= other [

	^ selector <= other selector
]

{ #category : #comparing }
SPMethod >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ selector = other selector and: [ self sourceHash = other sourceHash ]
]

{ #category : #converting }
SPMethod >> asSPMethod [

	^ self createSPMethod
]

{ #category : #comparing }
SPMethod >> hash [ 

	^ sourceHash hash
]

{ #category : #initialization }
SPMethod >> initSelector: aSelector source: aSource hash: aSourceHash selectorRefs: selRefs variableRefs: varRefs [ 

	selector := aSelector.
	source := aSource.
	sourceHash := aSourceHash.
	selectorRefs := selRefs.
	variableRefs := varRefs
]

{ #category : #accessing }
SPMethod >> messages [
	"Answer a collection of all the message selectors sent by this method."

	^ self selectorRefs select: [ :e | e isSend ] thenCollect: [ :e | e selector ]
]

{ #category : #accessing }
SPMethod >> messagesToSelf [
	^ self selectorRefs select: [ :each | each isToSelf ] thenCollect: [ :each | each selector ]
]

{ #category : #accessing }
SPMethod >> messagesToSuper [
	^ self selectorRefs select: [ :each | each isToSuper ] thenCollect: [ :each | each selector ]
]

{ #category : #accessing }
SPMethod >> pragmas [

	^ self selectorRefs select: [ :e | e isPragma ] thenCollect: [ :e | e selector ]
]

{ #category : #printing }
SPMethod >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $[.
	selector printOn: aStream.
	aStream nextPut: $#.
	aStream nextPutAll: (sourceHash last: 3) hex.
	aStream nextPut: $]
]

{ #category : #accessing }
SPMethod >> selector [
	^ selector
]

{ #category : #accessing }
SPMethod >> selectorRefAt: aSymbol [
	^ selectorRefs detect: [ :each | each selector = aSymbol ]
]

{ #category : #accessing }
SPMethod >> selectorRefs [
	^ selectorRefs
]

{ #category : #accessing }
SPMethod >> source [
	^ source
]

{ #category : #accessing }
SPMethod >> sourceHash [
	^ sourceHash
]

{ #category : #accessing }
SPMethod >> variableRefs [
	^ variableRefs
]

{ #category : #accessing }
SPMethod >> variables [ 

	^ self variableRefs collect: [ :each | each variable ]
]

{ #category : #accessing }
SPMethod >> variablesRead [ 

	^ self variableRefs select: [ :each | each isRead ] thenCollect:  [ :each | each variable ]
]

{ #category : #accessing }
SPMethod >> variablesWritten [

	^ self variableRefs select: [ :each | each isWrite ] thenCollect:  [ :each | each variable ]
]
