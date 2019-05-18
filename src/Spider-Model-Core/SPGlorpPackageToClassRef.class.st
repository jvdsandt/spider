Class {
	#name : #SPGlorpPackageToClassRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'spiderClass',
		'category'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPGlorpPackageToClassRef class >> spiderClass: aSpiderClass [

	^ self spiderClass: aSpiderClass category: nil
]

{ #category : #'instance creation' }
SPGlorpPackageToClassRef class >> spiderClass: aSpiderClass category: aCategory [

	^ self new initWithClass: aSpiderClass category: aCategory
]

{ #category : #comparing }
SPGlorpPackageToClassRef >> <= other [

	^ self name <= other name
]

{ #category : #comparing }
SPGlorpPackageToClassRef >> = other [

	self == other ifTrue: [ ^true ].
	self species = other species ifFalse: [ ^false ].
	
	^category = other category and: [ spiderClass = other spiderClass ]
]

{ #category : #accessing }
SPGlorpPackageToClassRef >> category [
	^ category
]

{ #category : #comparing }
SPGlorpPackageToClassRef >> hash [

	^ category hash bitXor: spiderClass hash
]

{ #category : #initialization }
SPGlorpPackageToClassRef >> initWithClass: aSpiderClass category: aCategory [

	spiderClass := aSpiderClass.
	category := aCategory
]

{ #category : #testing }
SPGlorpPackageToClassRef >> isSameRef: otherRef [

	^ self spiderClass = otherRef spiderClass and: [ self category = otherRef category ]
]

{ #category : #testing }
SPGlorpPackageToClassRef >> isSpiderClass [
	^ self spiderClass isSpiderClass
]

{ #category : #testing }
SPGlorpPackageToClassRef >> isSpiderClassExtension [
	^ self spiderClass isSpiderClassExtension
]

{ #category : #accessing }
SPGlorpPackageToClassRef >> name [
	^ self spiderClass name
]

{ #category : #printing }
SPGlorpPackageToClassRef >> printHashSignatureOn: aStream [

	aStream nextPutAll: self spiderClass classHash hex.
	category notNil
		ifTrue: [ aStream space; nextPutAll: category ]
]

{ #category : #accessing }
SPGlorpPackageToClassRef >> spiderClass [
	^ spiderClass
]

{ #category : #accessing }
SPGlorpPackageToClassRef >> spiderClassName [
	^ self spiderClass name
]
