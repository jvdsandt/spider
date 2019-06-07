Class {
	#name : #SPConfigurationBuilder,
	#superclass : #Object,
	#instVars : [
		'packages',
		'behaviors',
		'extensions'
	],
	#category : #'Spider-Model-Ring2'
}

{ #category : #adding }
SPConfigurationBuilder >> addPackage: aPackage [

	aPackage classRefs do: [ :each |
		each isSpiderClass 
			ifTrue: [ 
				behaviors at: each name put: each spiderClass ]
			ifFalse: [ 
				each isSpiderClassExtension 
					ifTrue: [ 
						(extensions at: each name ifAbsentPut: [ OrderedCollection new ])
							add: each spiderClass ]
					ifFalse: [ 
						self error: 'Unknown thing' ] ] ].

	packages add: aPackage
		
		
	
]

{ #category : #accessing }
SPConfigurationBuilder >> classNamed: aSymbol ifAbsent: aBlock [

	| clazz |
	
	clazz := behaviors at: aSymbol ifAbsent: [ nil ].
	^ (clazz notNil and: [ clazz isSpiderClass ])
			ifTrue: [ clazz ]
			ifFalse: [ aBlock value ]
]

{ #category : #accessing }
SPConfigurationBuilder >> extensionsFor: aClassName [

	^ extensions at: aClassName ifAbsent: [ #() ]
]

{ #category : #initialization }
SPConfigurationBuilder >> initialize [

	super initialize.
	
	packages := OrderedCollection new.
	behaviors := IdentityDictionary new.
	extensions := IdentityDictionary new.


]

{ #category : #accessing }
SPConfigurationBuilder >> packages [
	^ packages
]
