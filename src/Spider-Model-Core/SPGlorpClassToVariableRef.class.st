Class {
	#name : #SPGlorpClassToVariableRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'type',
		'variable',
		'expression'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #constants }
SPGlorpClassToVariableRef class >> classInstanceVarType [

	^ 62
]

{ #category : #'instance creation' }
SPGlorpClassToVariableRef class >> classVar: aVarSymbol [

	^ self type: self classVarType variable: aVarSymbol
]

{ #category : #constants }
SPGlorpClassToVariableRef class >> classVarType [

	^ 61
]

{ #category : #'instance creation' }
SPGlorpClassToVariableRef class >> classsInstanceVar: aVarSymbol [

	^ self type: self classInstanceVarType variable: aVarSymbol
]

{ #category : #'instance creation' }
SPGlorpClassToVariableRef class >> instanceVar: aVarSymbol [

	^ self type: self instanceVarType variable: aVarSymbol
]

{ #category : #'instance creation' }
SPGlorpClassToVariableRef class >> instanceVar: aVarSymbol expression: aString [

	^ self type: self instanceVarType variable: aVarSymbol expression: aString
]

{ #category : #constants }
SPGlorpClassToVariableRef class >> instanceVarType [

	^ 60
]

{ #category : #'instance creation' }
SPGlorpClassToVariableRef class >> poolVar: aVarSymbol [

	^ self type: self poolVarType variable: aVarSymbol
]

{ #category : #constants }
SPGlorpClassToVariableRef class >> poolVarType [

	^ 63
]

{ #category : #'instance creation' }
SPGlorpClassToVariableRef class >> type: anInteger variable: aVarSymbol [

	^ self type: anInteger variable: aVarSymbol expression: nil
]

{ #category : #'instance creation' }
SPGlorpClassToVariableRef class >> type: anInteger variable: aVarSymbol expression: aString [

	^ self new initType: anInteger variable: aVarSymbol expression: aString
]

{ #category : #comparing }
SPGlorpClassToVariableRef >> <= other [

	^ type = other type
			ifTrue: [ variable <= other variable ]
			ifFalse: [ type <= other type ]
]

{ #category : #comparing }
SPGlorpClassToVariableRef >> = other [

	self == other ifTrue: [ ^true ].
	self class = other class ifFalse: [ ^false ].
	
	^variable = other variable and: [ type = other type ]
]

{ #category : #accessing }
SPGlorpClassToVariableRef >> expression [
	^ expression ifNil: [ self variable printString ]
]

{ #category : #accessing }
SPGlorpClassToVariableRef >> expressionOrNil [
	^ expression

]

{ #category : #comparing }
SPGlorpClassToVariableRef >> hash [

	^ variable hash bitXor: type hash
]

{ #category : #initialization }
SPGlorpClassToVariableRef >> initType: anInteger variable: aVarSymbol expression: aString [

	type := anInteger.
	variable := aVarSymbol.
	expression := aString
]

{ #category : #testing }
SPGlorpClassToVariableRef >> isClassInstanceVar [

	^ self type = self class classInstanceVarType
]

{ #category : #testing }
SPGlorpClassToVariableRef >> isClassVar [

	^ self type = self class classVarType
]

{ #category : #testing }
SPGlorpClassToVariableRef >> isInstanceVar [

	^ self type = self class instanceVarType
]

{ #category : #testing }
SPGlorpClassToVariableRef >> isPoolVar [

	^ self type = self class poolVarType
]

{ #category : #printing }
SPGlorpClassToVariableRef >> printHashSignatureOn: aStream [

	aStream 
		print: self type;
		space;
		nextPutAll: (expression ifNil: [ self variable ])
]

{ #category : #accessing }
SPGlorpClassToVariableRef >> type [
	^ type
]

{ #category : #accessing }
SPGlorpClassToVariableRef >> variable [
	^ variable
]
