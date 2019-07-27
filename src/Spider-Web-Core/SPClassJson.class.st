Class {
	#name : #SPClassJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPClassJson >> renderClass: aClass on: aRenderer [

	aRenderer object: [ 
		self renderClassSummary: aClass on: aRenderer.
		aRenderer 
			key: 'comment' value: aClass comment;
			key: 'instanceMethods' value: [ self renderMethodRefs: aClass instanceMethodRefs on: aRenderer ]; 
			key: 'classMethods' value: [ self renderMethodRefs: aClass classMethodRefs on: aRenderer ].
		aClass isSpiderClassExtension
			ifFalse: [ self renderVariablesOf: aClass on: aRenderer ] ]
]

{ #category : #rendering }
SPClassJson >> renderClassSummary: aClass on: json [

	json
		key: 'id' value: aClass id;
		key: 'name' value: aClass name;
		key: 'type' value: aClass typeName.
	aClass isSpiderClass 
		ifTrue: [ json key: 'superclass' value: aClass superclassName ]
]

{ #category : #rendering }
SPClassJson >> renderMethodRefs: aList on: aRenderer [

	aRenderer array: [ 
		aList do: [ :each |
			aRenderer object: [ 
				aRenderer 
					key: 'id' value: each method id;
					key: 'selector' value: each selector;
					key: 'category' value: each category ] ] ]
]

{ #category : #rendering }
SPClassJson >> renderVariablesOf: aClass on: json [

	json key: 'instanceVariables' value: aClass instanceVarNames.
	json key: 'classVariables' value: aClass classVarNames.
	json key: 'classInstanceVariables' value: aClass classInstanceVarNames.
	json key: 'poolDictionaries' value: aClass poolDictionaryNames
]
