Class {
	#name : #SPClassToMethodRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'type',
		'category',
		'method'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPClassToMethodRef class >> classMethod: aMethod category: aCategory [

	^ self type: self classType method: aMethod category: aCategory
]

{ #category : #constants }
SPClassToMethodRef class >> classType [

	^ 51
]

{ #category : #'instance creation' }
SPClassToMethodRef class >> instanceMethod: aMethod category: aCategory [

	^ self type: self instanceType method: aMethod category: aCategory
]

{ #category : #constants }
SPClassToMethodRef class >> instanceType [

	^ 50
]

{ #category : #'instance creation' }
SPClassToMethodRef class >> type: anInteger method: aMethod category: aCategory [

	^ self new initType: anInteger method: aMethod category: aCategory
]

{ #category : #comparing }
SPClassToMethodRef >> <= other [

	^ type = other type
			ifTrue: [ self selector <= other selector ]
			ifFalse: [ type <= other type ]
]

{ #category : #comparing }
SPClassToMethodRef >> = other [

	self == other ifTrue: [ ^true ].
	self species = other species ifFalse: [ ^false ].
	
	^type = other type and: [
		category = other category and: [
			method = other method ] ]
]

{ #category : #accessing }
SPClassToMethodRef >> category [
	^ category
]

{ #category : #accessing }
SPClassToMethodRef >> diffKey [

	^ Array with: self type with: self selector
]

{ #category : #comparing }
SPClassToMethodRef >> hash [

	^ self method hash bitXor: type hash
]

{ #category : #initialization }
SPClassToMethodRef >> initType: anInteger method: aMethod category: aCategory [

	type := anInteger.
	method := aMethod.
	category := aCategory
]

{ #category : #testing }
SPClassToMethodRef >> isClassSide [

	^ type = self class classType
]

{ #category : #testing }
SPClassToMethodRef >> isInstanceSide [

	^ type = self class instanceType
]

{ #category : #testing }
SPClassToMethodRef >> isSameRef: otherRef [

	^ self method = otherRef method and: [ 
			self type = otherRef type and: [ 
				self category = otherRef category ] ]
]

{ #category : #accessing }
SPClassToMethodRef >> method [
	^ method
]

{ #category : #printing }
SPClassToMethodRef >> printHashSignatureOn: aStream [

	aStream 
		print: self type;
		space;
		nextPutAll: self method sourceHash hex.
	category notNil
		ifTrue: [ aStream space; nextPutAll: category ]
]

{ #category : #printing }
SPClassToMethodRef >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $[.
	method printOn: aStream.
	aStream nextPut: $,.
	category printOn: aStream. 
]

{ #category : #accessing }
SPClassToMethodRef >> selector [

	^ self method selector
]

{ #category : #accessing }
SPClassToMethodRef >> type [
	^ type
]
