Class {
	#name : #SPMethodToVariableRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'variable',
		'flags'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #constants }
SPMethodToVariableRef class >> flagRead [
	^ 2r00000001
]

{ #category : #constants }
SPMethodToVariableRef class >> flagWrite [
	^ 2r00000010
]

{ #category : #'instance creation' }
SPMethodToVariableRef class >> variable: aSymbol flags: anInteger [

	^self new initVariable: aSymbol flags: anInteger
]

{ #category : #comparing }
SPMethodToVariableRef >> <= other [

	^variable <= other variable
]

{ #category : #comparing }
SPMethodToVariableRef >> = other [

	self == other ifTrue: [ ^true ].
	self class = other class ifFalse: [ ^false ].
	
	^self variable = other variable and: [ self flags = other flags ]
]

{ #category : #accessing }
SPMethodToVariableRef >> flags [
	^ flags
]

{ #category : #comparing }
SPMethodToVariableRef >> hash [ 

	^variable hash bitXor: flags hash
]

{ #category : #initialization }
SPMethodToVariableRef >> initVariable: aSymbol flags: anInteger [

	variable := aSymbol.
	flags := anInteger 
]

{ #category : #testing }
SPMethodToVariableRef >> isRead [

	^(flags bitAnd: self class flagRead) ~= 0
]

{ #category : #testing }
SPMethodToVariableRef >> isWrite [

	^(flags bitAnd: self class flagWrite) ~= 0
]

{ #category : #printing }
SPMethodToVariableRef >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	variable printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
SPMethodToVariableRef >> variable [
	^ variable
]
