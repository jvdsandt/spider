Class {
	#name : #SPMethodToSelectorRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'selector',
		'flags'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #constants }
SPMethodToSelectorRef class >> flagPragma [

	^ 2r10000000
]

{ #category : #constants }
SPMethodToSelectorRef class >> flagSelfSend [

	^ 2r00000010
]

{ #category : #constants }
SPMethodToSelectorRef class >> flagSend [

	^ 2r00000001
]

{ #category : #constants }
SPMethodToSelectorRef class >> flagSuperSend [

	^ 2r00000100
]

{ #category : #'instance creation' }
SPMethodToSelectorRef class >> selector: aSymbol flags: anInteger [

	^self new initSelector: aSymbol flags: anInteger
]

{ #category : #comparing }
SPMethodToSelectorRef >> <= other [

	^selector <= other selector
]

{ #category : #comparing }
SPMethodToSelectorRef >> = other [

	self == other ifTrue: [ ^true ].
	self class = other class ifFalse: [ ^false ].
	
	^self selector = other selector and: [ self flags = other flags ]
]

{ #category : #accessing }
SPMethodToSelectorRef >> flags [
	^ flags
]

{ #category : #comparing }
SPMethodToSelectorRef >> hash [ 

	^selector hash bitXor: flags hash
]

{ #category : #initialization }
SPMethodToSelectorRef >> initSelector: aSymbol flags: anInteger [

	selector := aSymbol.
	flags := anInteger.
]

{ #category : #testing }
SPMethodToSelectorRef >> isPragma [

	^(flags bitAnd: self class flagPragma) ~= 0
]

{ #category : #testing }
SPMethodToSelectorRef >> isSend [

	^(flags bitAnd: self class flagSend) ~= 0
]

{ #category : #testing }
SPMethodToSelectorRef >> isToSelf [

	^(flags bitAnd: self class flagSelfSend) ~= 0
]

{ #category : #testing }
SPMethodToSelectorRef >> isToSuper [

	^(flags bitAnd: self class flagSuperSend) ~= 0
]

{ #category : #printing }
SPMethodToSelectorRef >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	selector printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
SPMethodToSelectorRef >> selector [
	^ selector
]
