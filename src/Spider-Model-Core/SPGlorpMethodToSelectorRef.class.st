Class {
	#name : #SPGlorpMethodToSelectorRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'selector',
		'flags'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #constants }
SPGlorpMethodToSelectorRef class >> flagPragma [

	^ 2r10000000
]

{ #category : #constants }
SPGlorpMethodToSelectorRef class >> flagSelfSend [

	^ 2r00000010
]

{ #category : #constants }
SPGlorpMethodToSelectorRef class >> flagSend [

	^ 2r00000001
]

{ #category : #constants }
SPGlorpMethodToSelectorRef class >> flagSuperSend [

	^ 2r00000100
]

{ #category : #'instance creation' }
SPGlorpMethodToSelectorRef class >> selector: aSymbol flags: anInteger [

	^self new initSelector: aSymbol flags: anInteger
]

{ #category : #comparing }
SPGlorpMethodToSelectorRef >> <= other [

	^selector <= other selector
]

{ #category : #comparing }
SPGlorpMethodToSelectorRef >> = other [

	self == other ifTrue: [ ^true ].
	self class = other class ifFalse: [ ^false ].
	
	^self selector = other selector and: [ self flags = other flags ]
]

{ #category : #accessing }
SPGlorpMethodToSelectorRef >> flags [
	^ flags
]

{ #category : #comparing }
SPGlorpMethodToSelectorRef >> hash [ 

	^selector hash bitXor: flags hash
]

{ #category : #initialization }
SPGlorpMethodToSelectorRef >> initSelector: aSymbol flags: anInteger [

	selector := aSymbol.
	flags := anInteger.
]

{ #category : #testing }
SPGlorpMethodToSelectorRef >> isPragma [

	^(flags bitAnd: self class flagPragma) ~= 0
]

{ #category : #testing }
SPGlorpMethodToSelectorRef >> isSend [

	^(flags bitAnd: self class flagSend) ~= 0
]

{ #category : #testing }
SPGlorpMethodToSelectorRef >> isToSelf [

	^(flags bitAnd: self class flagSelfSend) ~= 0
]

{ #category : #testing }
SPGlorpMethodToSelectorRef >> isToSuper [

	^(flags bitAnd: self class flagSuperSend) ~= 0
]

{ #category : #printing }
SPGlorpMethodToSelectorRef >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	selector printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
SPGlorpMethodToSelectorRef >> selector [
	^ selector
]
