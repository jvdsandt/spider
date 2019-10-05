Class {
	#name : #SPClassJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPClassJson >> renderClass: aClass in: aCategory on: aRenderer [

	| gitCommit mcPackage |
	
	gitCommit := nil. "aClass oldestGitCommit."
	mcPackage := nil. "aClass oldestMCPackage."

	aRenderer object: [ 
		self renderClassSummary: aClass on: aRenderer.
		aRenderer 
			key: 'comment' value: aClass comment.
		aClass isSpiderClassExtension
			ifFalse: [ 
				aRenderer
					key: 'definition' value: (aClass definitionIn: aCategory);
					key: 'classDefinition' value: (aClass classDefinitionIn: aCategory).
				self renderVariablesOf: aClass on: aRenderer ].
		aRenderer
			key: 'instanceMethods' value: [ self renderMethodRefs: aClass instanceMethodRefs on: aRenderer ]; 
			key: 'classMethods' value: [ self renderMethodRefs: aClass classMethodRefs on: aRenderer ].
		aRenderer 
			key: 'gitCommit' value: (gitCommit ifNotNil: [
				[ aRenderer object: [ self renderGitCommitSummary: gitCommit on: aRenderer ]	] ]);
			key: 'mcPackage' value: (mcPackage ifNotNil: [
				[ aRenderer object: [ self renderMCPackageSummary: mcPackage on: aRenderer ] ] ])
	]
]

{ #category : #rendering }
SPClassJson >> renderClass: aClass on: aRenderer [

	self renderClass: aClass in: nil on: aRenderer 
]

{ #category : #rendering }
SPClassJson >> renderClassSummary: aClass in: aCategory on: json [

	json
		key: 'id' value: aClass id;
		key: 'name' value: aClass name;
		key: 'type' value: aClass typeName.
	aClass isSpiderClass 
		ifTrue: [ json key: 'superclass' value: aClass superclassName ].
	json key: 'category' value: aCategory
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
	aClass isSpiderTrait 
		ifFalse: [ 
			json key: 'classInstanceVariables' value: aClass classInstanceVarNames.
			json key: 'poolDictionaries' value: aClass poolDictionaryNames ]
]
