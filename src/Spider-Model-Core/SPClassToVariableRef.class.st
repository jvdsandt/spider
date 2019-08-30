Class {
	#name : #SPClassToVariableRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'type',
		'variable',
		'expression'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPClassToVariableRef class >> classInstanceVar: aVarSymbol [

	^ self type: self classInstanceVarType variable: aVarSymbol
]

{ #category : #constants }
SPClassToVariableRef class >> classInstanceVarType [

	^ 62
]

{ #category : #'instance creation' }
SPClassToVariableRef class >> classVar: aVarSymbol [

	^ self type: self classVarType variable: aVarSymbol
]

{ #category : #constants }
SPClassToVariableRef class >> classVarType [

	^ 61
]

{ #category : #'instance creation' }
SPClassToVariableRef class >> instanceVar: aVarSymbol [

	^ self type: self instanceVarType variable: aVarSymbol
]

{ #category : #'instance creation' }
SPClassToVariableRef class >> instanceVar: aVarSymbol expression: aString [

	^ self type: self instanceVarType variable: aVarSymbol expression: aString
]

{ #category : #constants }
SPClassToVariableRef class >> instanceVarType [

	^ 60
]

{ #category : #'instance creation' }
SPClassToVariableRef class >> poolVar: aVarSymbol [

	^ self type: self poolVarType variable: aVarSymbol
]

{ #category : #constants }
SPClassToVariableRef class >> poolVarType [

	^ 63
]

{ #category : #'instance creation' }
SPClassToVariableRef class >> type: anInteger variable: aVarSymbol [

	^ self type: anInteger variable: aVarSymbol expression: nil
]

{ #category : #'instance creation' }
SPClassToVariableRef class >> type: anInteger variable: aVarSymbol expression: aString [

	^ self new initType: anInteger variable: aVarSymbol expression: aString
]

{ #category : #comparing }
SPClassToVariableRef >> <= other [

	^ type = other type
			ifTrue: [ variable <= other variable ]
			ifFalse: [ type <= other type ]
]

{ #category : #comparing }
SPClassToVariableRef >> = other [

	self == other ifTrue: [ ^true ].
	self class = other class ifFalse: [ ^false ].
	
	^variable = other variable and: [ type = other type ]
]

{ #category : #accessing }
SPClassToVariableRef >> expression [
	^ expression ifNil: [ self variable printString ]
]

{ #category : #accessing }
SPClassToVariableRef >> expressionOrNil [
	^ expression

]

{ #category : #testing }
SPClassToVariableRef >> hasExpression [

	^ expression notNil
]

{ #category : #comparing }
SPClassToVariableRef >> hash [

	^ variable hash bitXor: type hash
]

{ #category : #initialization }
SPClassToVariableRef >> initType: anInteger variable: aVarSymbol expression: aString [

	type := anInteger.
	variable := aVarSymbol.
	expression := aString
]

{ #category : #testing }
SPClassToVariableRef >> isClassInstanceVar [

	^ self type = self class classInstanceVarType
]

{ #category : #testing }
SPClassToVariableRef >> isClassVar [

	^ self type = self class classVarType
]

{ #category : #testing }
SPClassToVariableRef >> isInstanceVar [

	^ self type = self class instanceVarType
]

{ #category : #testing }
SPClassToVariableRef >> isPoolVar [

	^ self type = self class poolVarType
]

{ #category : #printing }
SPClassToVariableRef >> printHashSignatureOn: aStream [

	aStream 
		print: self type;
		space;
		nextPutAll: (expression ifNil: [ self variable ])
]

{ #category : #accessing }
SPClassToVariableRef >> type [
	^ type
]

{ #category : #accessing }
SPClassToVariableRef >> variable [
	^ variable
]
