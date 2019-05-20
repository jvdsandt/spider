Class {
	#name : #SPBrowser,
	#superclass : #Object,
	#instVars : [
		'packages',
		'selectedPackage',
		'selectedClass',
		'showInstance',
		'selectedCategory',
		'selectedMethod'
	],
	#category : #'Spider-Web-Core-Browser'
}

{ #category : #'instance creation' }
SPBrowser class >> onPackage: aPackage [

	^ self new
		packages: (Array with: aPackage);
		selectedPackage: aPackage;
		yourself
]

{ #category : #accessing }
SPBrowser >> categories [

	| fixedCategories |
	
	fixedCategories := Array with: '-- all --'.

	^ self selectedClass
			ifNil: [ #() ]
			ifNotNil: [ 
				self showInstance 
					ifTrue: [ fixedCategories, self selectedClass instanceCategories ]
					ifFalse: [ fixedCategories, self selectedClass classCategories ] ]
]

{ #category : #accessing }
SPBrowser >> classes [

	^ self selectedPackage 
			ifNil: [ #() ]
			ifNotNil: [ self selectedPackage classes sorted: [ :c1 :c2 | c1 name <= c2 name ] ]
]

{ #category : #accessing }
SPBrowser >> doShowClassSide [

	showInstance := false.

	selectedCategory := nil.
	selectedMethod := nil.
]

{ #category : #accessing }
SPBrowser >> doShowInstanceSide [

	showInstance := true.
	
	selectedCategory := nil.
	selectedMethod := nil.
]

{ #category : #accessing }
SPBrowser >> methods [

	^ self selectedClass
			ifNil: [ #() ]
			ifNotNil: [ 
				self showInstance 
					ifTrue: [ self selectedClass instanceMethods sorted ]
					ifFalse: [ self selectedClass classMethods sorted ] ]
]

{ #category : #accessing }
SPBrowser >> packages [
	^ packages
]

{ #category : #accessing }
SPBrowser >> packages: anObject [
	packages := anObject
]

{ #category : #accessing }
SPBrowser >> selectedCategory [
	^ selectedCategory
]

{ #category : #accessing }
SPBrowser >> selectedCategory: anObject [
	selectedCategory := anObject
]

{ #category : #accessing }
SPBrowser >> selectedClass [
	^ selectedClass
]

{ #category : #accessing }
SPBrowser >> selectedClass: anObject [
	selectedClass := anObject
]

{ #category : #accessing }
SPBrowser >> selectedMethod [
	^ selectedMethod
]

{ #category : #accessing }
SPBrowser >> selectedMethod: anObject [
	selectedMethod := anObject
]

{ #category : #accessing }
SPBrowser >> selectedPackage [
	^ selectedPackage
]

{ #category : #accessing }
SPBrowser >> selectedPackage: anObject [
	selectedPackage := anObject
]

{ #category : #accessing }
SPBrowser >> showInstance [

	^ showInstance ifNil: [ showInstance := true ]
]

{ #category : #accessing }
SPBrowser >> source [

	^ self selectedMethod
			ifNil: [ '' ]
			ifNotNil: [ self selectedMethod source ]
]
