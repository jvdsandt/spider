Class {
	#name : #SPGlorpMethodToVariableRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'variable',
		'flags'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #constants }
SPGlorpMethodToVariableRef class >> flagRead [
	^ 2r00000001
]

{ #category : #constants }
SPGlorpMethodToVariableRef class >> flagWrite [
	^ 2r00000010
]

{ #category : #'instance creation' }
SPGlorpMethodToVariableRef class >> variable: aSymbol flags: anInteger [

	^self new initVariable: aSymbol flags: anInteger
]

{ #category : #comparing }
SPGlorpMethodToVariableRef >> <= other [

	^variable <= other variable
]

{ #category : #comparing }
SPGlorpMethodToVariableRef >> = other [

	self == other ifTrue: [ ^true ].
	self class = other class ifFalse: [ ^false ].
	
	^self variable = other variable and: [ self flags = other flags ]
]

{ #category : #accessing }
SPGlorpMethodToVariableRef >> flags [
	^ flags
]

{ #category : #comparing }
SPGlorpMethodToVariableRef >> hash [ 

	^variable hash bitXor: flags hash
]

{ #category : #initialization }
SPGlorpMethodToVariableRef >> initVariable: aSymbol flags: anInteger [

	variable := aSymbol.
	flags := anInteger 
]

{ #category : #testing }
SPGlorpMethodToVariableRef >> isRead [

	^(flags bitAnd: self class flagRead) ~= 0
]

{ #category : #testing }
SPGlorpMethodToVariableRef >> isWrite [

	^(flags bitAnd: self class flagWrite) ~= 0
]

{ #category : #printing }
SPGlorpMethodToVariableRef >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $(.
	variable printOn: aStream.
	aStream nextPut: $)
]

{ #category : #accessing }
SPGlorpMethodToVariableRef >> variable [
	^ variable
]
