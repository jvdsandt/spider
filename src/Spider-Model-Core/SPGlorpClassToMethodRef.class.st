Class {
	#name : #SPGlorpClassToMethodRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'type',
		'category',
		'method'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPGlorpClassToMethodRef class >> classMethod: aMethod category: aCategory [

	^ self type: self classType method: aMethod category: aCategory
]

{ #category : #constants }
SPGlorpClassToMethodRef class >> classType [

	^ 51
]

{ #category : #'instance creation' }
SPGlorpClassToMethodRef class >> instanceMethod: aMethod category: aCategory [

	^ self type: self instanceType method: aMethod category: aCategory
]

{ #category : #constants }
SPGlorpClassToMethodRef class >> instanceType [

	^ 50
]

{ #category : #'instance creation' }
SPGlorpClassToMethodRef class >> type: anInteger method: aMethod category: aCategory [

	^ self new initType: anInteger method: aMethod category: aCategory
]

{ #category : #comparing }
SPGlorpClassToMethodRef >> <= other [

	^ type = other type
			ifTrue: [ self selector <= other selector ]
			ifFalse: [ type <= other type ]
]

{ #category : #comparing }
SPGlorpClassToMethodRef >> = other [

	self == other ifTrue: [ ^true ].
	self species = other species ifFalse: [ ^false ].
	
	^type = other type and: [
		category = other category and: [
			method = other method ] ]
]

{ #category : #accessing }
SPGlorpClassToMethodRef >> category [
	^ category
]

{ #category : #comparing }
SPGlorpClassToMethodRef >> hash [

	^ self method hash bitXor: type hash
]

{ #category : #initialization }
SPGlorpClassToMethodRef >> initType: anInteger method: aMethod category: aCategory [

	type := anInteger.
	method := aMethod.
	category := aCategory
]

{ #category : #testing }
SPGlorpClassToMethodRef >> isClassSide [

	^ type = self class classType
]

{ #category : #testing }
SPGlorpClassToMethodRef >> isInstanceSide [

	^ type = self class instanceType
]

{ #category : #testing }
SPGlorpClassToMethodRef >> isSameRef: otherRef [

	^ self method = otherRef method and: [ 
			self type = otherRef type and: [ 
				self category = otherRef category ] ]
]

{ #category : #accessing }
SPGlorpClassToMethodRef >> method [
	^ method
]

{ #category : #printing }
SPGlorpClassToMethodRef >> printHashSignatureOn: aStream [

	aStream 
		print: self type;
		space;
		nextPutAll: self method sourceHash hex.
	category notNil
		ifTrue: [ aStream space; nextPutAll: category ]
]

{ #category : #printing }
SPGlorpClassToMethodRef >> printOn: aStream [

	super printOn: aStream.
	
	aStream nextPut: $[.
	method printOn: aStream.
	aStream nextPut: $,.
	category printOn: aStream. 
]

{ #category : #testing }
SPGlorpClassToMethodRef >> selector [

	^ self method selector
]

{ #category : #accessing }
SPGlorpClassToMethodRef >> type [
	^ type
]
