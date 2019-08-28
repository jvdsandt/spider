Class {
	#name : #SPPackageToClassRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'spiderClass',
		'category'
	],
	#category : #'Spider-Model-Core-Domain'
}

{ #category : #'instance creation' }
SPPackageToClassRef class >> spiderClass: aSpiderClass [

	^ self spiderClass: aSpiderClass category: nil
]

{ #category : #'instance creation' }
SPPackageToClassRef class >> spiderClass: aSpiderClass category: aCategory [

	^ self new initWithClass: aSpiderClass category: aCategory
]

{ #category : #comparing }
SPPackageToClassRef >> <= other [

	^ self name <= other name
]

{ #category : #comparing }
SPPackageToClassRef >> = other [

	self == other ifTrue: [ ^true ].
	self species = other species ifFalse: [ ^false ].
	
	^category = other category and: [ spiderClass = other spiderClass ]
]

{ #category : #accessing }
SPPackageToClassRef >> category [
	^ category
]

{ #category : #accessing }
SPPackageToClassRef >> fullCategoryIn: aPackage [

	^ self category isNil
			ifTrue: [ aPackage name ]
			ifFalse: [ aPackage name, '-', self category ]
]

{ #category : #comparing }
SPPackageToClassRef >> hash [

	^ category hash bitXor: spiderClass hash
]

{ #category : #initialization }
SPPackageToClassRef >> initWithClass: aSpiderClass category: aCategory [

	spiderClass := aSpiderClass.
	category := aCategory
]

{ #category : #testing }
SPPackageToClassRef >> isSameRef: otherRef [

	^ self spiderClass = otherRef spiderClass and: [ self category = otherRef category ]
]

{ #category : #testing }
SPPackageToClassRef >> isSpiderClass [
	^ self spiderClass isSpiderClass
]

{ #category : #testing }
SPPackageToClassRef >> isSpiderClassExtension [
	^ self spiderClass isSpiderClassExtension
]

{ #category : #testing }
SPPackageToClassRef >> isSpiderTrait [
	^ self spiderClass isSpiderTrait
]

{ #category : #accessing }
SPPackageToClassRef >> name [
	^ self spiderClass name
]

{ #category : #printing }
SPPackageToClassRef >> printHashSignatureOn: aStream [

	aStream nextPutAll: self spiderClass classHash hex.
	category notNil
		ifTrue: [ aStream space; nextPutAll: category ]
]

{ #category : #accessing }
SPPackageToClassRef >> spiderClass [
	^ spiderClass
]

{ #category : #accessing }
SPPackageToClassRef >> spiderClassName [
	^ self spiderClass name
]
