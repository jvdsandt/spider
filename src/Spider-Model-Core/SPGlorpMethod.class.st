Class {
	#name : #SPGlorpMethod,
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
SPGlorpMethod class >> flagPragma [

	^ 2r10000000
]

{ #category : #constants }
SPGlorpMethod class >> flagSelfSend [

	^ 2r00000010
]

{ #category : #'instance creation' }
SPGlorpMethod class >> selector: aSelector source: aSource hash: aSourceHash selectorRefs: selRefs variableRefs: varRefs [ 

	^ self new initSelector: aSelector 
			source: aSource 
			hash: aSourceHash 
			selectorRefs: selRefs 
			variableRefs: varRefs 
]

{ #category : #comparing }
SPGlorpMethod >> <= other [

	^ selector <= other selector
]

{ #category : #comparing }
SPGlorpMethod >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ selector = other selector and: [ self sourceHash = other sourceHash ]
]

{ #category : #converting }
SPGlorpMethod >> asSPMethod [

	^ self createSPMethod
]

{ #category : #comparing }
SPGlorpMethod >> hash [ 

	^ sourceHash hash
]

{ #category : #initialization }
SPGlorpMethod >> initSelector: aSelector source: aSource hash: aSourceHash selectorRefs: selRefs variableRefs: varRefs [ 

	selector := aSelector.
	source := aSource.
	sourceHash := aSourceHash.
	selectorRefs := selRefs.
	variableRefs := varRefs
]

{ #category : #accessing }
SPGlorpMethod >> messages [
	"Answer a collection of all the message selectors sent by this method."

	^ self selectorRefs select: [ :e | e isSend ] thenCollect: [ :e | e selector ]
]

{ #category : #accessing }
SPGlorpMethod >> messagesToSelf [
	^ self selectorRefs select: [ :each | each isToSelf ] thenCollect: [ :each | each selector ]
]

{ #category : #accessing }
SPGlorpMethod >> messagesToSuper [
	^ self selectorRefs select: [ :each | each isToSuper ] thenCollect: [ :each | each selector ]
]

{ #category : #accessing }
SPGlorpMethod >> pragmas [

	^ self selectorRefs select: [ :e | e isPragma ] thenCollect: [ :e | e selector ]
]

{ #category : #printing }
SPGlorpMethod >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $[.
	selector printOn: aStream.
	aStream nextPut: $#.
	aStream nextPutAll: (sourceHash last: 3) hex.
	aStream nextPut: $]
]

{ #category : #accessing }
SPGlorpMethod >> selector [
	^ selector
]

{ #category : #accessing }
SPGlorpMethod >> selectorRefAt: aSymbol [
	^ selectorRefs detect: [ :each | each selector = aSymbol ]
]

{ #category : #accessing }
SPGlorpMethod >> selectorRefs [
	^ selectorRefs
]

{ #category : #accessing }
SPGlorpMethod >> source [
	^ source
]

{ #category : #accessing }
SPGlorpMethod >> sourceHash [
	^ sourceHash
]

{ #category : #accessing }
SPGlorpMethod >> variableRefs [
	^ variableRefs
]

{ #category : #accessing }
SPGlorpMethod >> variables [ 

	^ self variableRefs collect: [ :each | each variable ]
]

{ #category : #accessing }
SPGlorpMethod >> variablesRead [ 

	^ self variableRefs select: [ :each | each isRead ] thenCollect:  [ :each | each variable ]
]

{ #category : #accessing }
SPGlorpMethod >> variablesWritten [

	^ self variableRefs select: [ :each | each isWrite ] thenCollect:  [ :each | each variable ]
]
