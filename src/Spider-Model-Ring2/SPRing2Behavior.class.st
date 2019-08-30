Class {
	#name : #SPRing2Behavior,
	#superclass : #Object,
	#instVars : [
		'category',
		'spiderClass'
	],
	#category : #'Spider-Model-Ring2'
}

{ #category : #comparing }
SPRing2Behavior >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].

	^ category = other category and: [ spiderClass = other spiderClass ]
]

{ #category : #converting }
SPRing2Behavior >> asRGDefinition [

	^ self ensureRingDefinitionIn: RGEnvironment new
]

{ #category : #accessing }
SPRing2Behavior >> category [
	^ category
]

{ #category : #accessing }
SPRing2Behavior >> classDefinition [

	^ self asRGDefinition metaclass definition
]

{ #category : #accessing }
SPRing2Behavior >> classTraitCompositionString [

	^ self spiderClass classTraitCompositionString 
]

{ #category : #accessing }
SPRing2Behavior >> comment [

	^ self spiderClass comment
]

{ #category : #accessing }
SPRing2Behavior >> definition [

	^ self asRGDefinition definition
]

{ #category : #comparing }
SPRing2Behavior >> hash [

	^ spiderClass hash
]

{ #category : #initialization }
SPRing2Behavior >> initWith: aSpiderClass category: aCategory [

	spiderClass := aSpiderClass.
	category := aCategory
]

{ #category : #accessing }
SPRing2Behavior >> name [

	^ self spiderClass name
]

{ #category : #accessing }
SPRing2Behavior >> spiderClass [
	^ spiderClass
]

{ #category : #internal }
SPRing2Behavior >> traitCompositionFrom: aStringOrNil parent: aBehavior [
	
	| composition transformations |
	
	composition := RGTraitComposition parent: aBehavior.

	aStringOrNil ifNil: [ ^ composition ].

	transformations := RGTraitCompositionVisitor new parse: aStringOrNil for: composition.
	transformations do: [ :each |
		composition addTransformation: each ].
	^ composition
]

{ #category : #accessing }
SPRing2Behavior >> traitCompositionString [

	^ self spiderClass traitCompositionString 
]
