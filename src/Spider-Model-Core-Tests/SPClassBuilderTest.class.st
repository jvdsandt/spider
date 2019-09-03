Class {
	#name : #SPClassBuilderTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #running }
SPClassBuilderTest >> createMethodFromSource: aString [

	^ SPMethodBuilder new
		setSource: aString;
		build
]

{ #category : #tests }
SPClassBuilderTest >> testArrayClass [

	| class |
	
	class := SPClassBuilder new
		setClass: Array;
		build.
		
	self assert: #Array equals: class name.
	self assert: #variable equals: class classType.

]

{ #category : #tests }
SPClassBuilderTest >> testBooleanClass [

	| class class2 |
	
	class := SPClassBuilder new
		setClass: Boolean;
		build.
		
	self assert: #Boolean equals: class name.
	self assert: #Object equals: class superclassName.
	self assert: #normal equals: class classType.
	
	self assert: (class instanceSelectors includes: #and:).
	
	class2 := SPClassBuilder new
		setClass: Boolean;
		build.

	self assert: class classHash equals: class2 classHash.
	self assert: class hash equals: class2 hash.
	self assert: class equals: class2.

]

{ #category : #tests }
SPClassBuilderTest >> testBuildClass [

	| class |
	
	class := SPClassBuilder new
		name: #EmptyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addClassMethodSource: 'm2 ^123' category: 'resources';
		build.
		
	self assert: #EmptyClass equals: class name.
	self assert: #Object equals: class superclassName.
	self assert: #normal equals: class classType.
	self assert: class instanceSelectors equals: #( m1 ).
	self assert: class classSelectors equals: #( m2 ).
]

{ #category : #tests }
SPClassBuilderTest >> testBuildEmptyClass [

	| class |
	
	class := SPClassBuilder new
		name: #EmptyClass;
		build.
		
	self assert: #EmptyClass equals: class name.
	self assert: #Object equals: class superclassName.
	self assert: #normal equals: class classType.
]

{ #category : #tests }
SPClassBuilderTest >> testBuildEmptyClassExtension [

	| classExt |
	
	classExt := SPClassExtensionBuilder new
		name: #EmptyClass;
		build.
		
	self assert: #EmptyClass equals: classExt name.

]

{ #category : #tests }
SPClassBuilderTest >> testBuildWithDuplicateSelectorsGivesError [
	"Allow duplicate selector fow now"
	<expectedFailure>

	self should: [
		SPClassBuilder new
			name: #EmptyClass;
			addInstanceMethodSource: 'm1 ^123' category: 'resources';
			addInstanceMethodSource: 'm1 ^456' category: 'other';
			build ] raise: Error.
		
	self should: [
		SPClassBuilder new
			name: #EmptyClass;
			addClassMethodSource: 'm1 ^123' category: 'resources';
			addClassMethodSource: 'm1 ^456' category: 'other';
			build ] raise: Error.
		
	SPClassBuilder new
		name: #EmptyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addClassMethodSource: 'm1 ^123' category: 'resources';
		build
]

{ #category : #tests }
SPClassBuilderTest >> testBuildWithSameMethodTwiceIsIgnored [

	| spiderClass |
	
	spiderClass := SPClassBuilder new
		name: #EmptyClass;
		addInstanceMethodSource: 'm1 ^123' category: 'resources';
		addInstanceMethodSource: 'm1 ^123' category: 'other';
		build.
		
	self assert: spiderClass instanceMethodRefs size equals: 1.
	
	spiderClass := SPClassBuilder new
		name: #EmptyClass;
		addClassMethodSource: 'm1 ^123' category: 'resources';
		addClassMethodSource: 'm1 ^123' category: 'other';
		build.
		
	self assert: spiderClass classMethodRefs size equals: 1
	

]

{ #category : #tests }
SPClassBuilderTest >> testClassExtension [

	| classExt |
	
	classExt := SPClassExtensionBuilder new
		setClass: Object instMethods: (Array with: Object >> #externalCallFailed) classMethods: #();
		build.
		
	self assert: #Object equals: classExt name.
	self assert: classExt isSpiderClassExtension.
	self assert: classExt instanceSelectors equals: #( externalCallFailed ).
	self assert: classExt classSelectors equals: #().
]

{ #category : #tests }
SPClassBuilderTest >> testDateClass [

	| class |
	
	class := SPClassBuilder new
		setClass: Date;
		build.
		
	self assert: #Date equals: class name.
	self assert: #normal equals: class classType.
	
	self assert: (class classSelectors includes: #today)


]

{ #category : #tests }
SPClassBuilderTest >> testObjectClass [

	| class |
	
	class := SPClassBuilder new
		setClass: Object;
		build.
		
	self assert: #Object equals: class name.
	self assert: #normal equals: class classType.

]

{ #category : #tests }
SPClassBuilderTest >> testSlotExampleMovieClass [

	| class |
	
	class := SPClassBuilder new
		setClass: SlotExampleMovie;
		build.
		
	self assert: #SlotExampleMovie equals: class name.
	self assert: #normal equals: class classType.
	
	self assert: class instanceVarNames sorted equals: #( actors director name year ).
	
	self assert: (class instanceVarRefNamed: #year) variable equals: #year.
	self assert: (class instanceVarRefNamed: #year) expression equals: '#year'.
	self assert: (class instanceVarRefNamed: #year) expressionOrNil equals: nil.
	self assert: (class instanceVarRefNamed: #director) expression equals: '#director => ToOneRelationSlot inverse: #directedMovies inClass: #SlotExamplePerson'.
	
	


]

{ #category : #tests }
SPClassBuilderTest >> testTraits [

	| spTrait spClass |
	
	spClass := SPClassBuilder new
		setClass: SPTestTraitUser;
		build.
		
	spTrait := SPClassBuilder new
		setClass: SPTestTrait;
		build.
		
	self assert: spClass isSpiderClass.
	self deny: spClass isSpiderTrait.
	self assert: spTrait isSpiderTrait.
	self assert: spTrait isSpiderClass.
	self assert: #Object equals: spClass superclassName.
	self assert: nil equals: spTrait superclassName.
	
	self assert: 1 equals: spClass methodRefs size.
	self assert: #doStuff equals: spClass methodRefs first selector.
	
	self assert: 1 equals: spTrait methodRefs size.
	self assert: #doTraitStuff equals: spTrait methodRefs first selector.
	
	self assert: 'SPTestTrait' equals: SPTestTraitUser traitCompositionString.
	self assert: 'SPTestTrait classTrait' equals: SPTestTraitUser class traitCompositionString.

	self assert: 'SPTestTrait' equals: spClass traitCompositionString.
	self assert: 'SPTestTrait classTrait' equals: spClass classTraitCompositionString.
	
	
	


]

{ #category : #tests }
SPClassBuilderTest >> testTraitsMeta [

	| spClass |
	
	spClass := SPClassBuilder new
		setClass: SPTestTraitMetaUser;
		build.
		
	self assert: spClass isSpiderClass.
	self deny: spClass isSpiderTrait.
	self assert: #Object equals: spClass superclassName.
	
	self assert: 1 equals: spClass methodRefs size.
	self assert: #nothingHere equals: spClass methodRefs first selector.

	self assert: '{}' equals: SPTestTraitMetaUser traitCompositionString.
	self assert: 'SPTestTrait' equals: SPTestTraitMetaUser class traitCompositionString.
	
	self assert: nil equals: spClass traitCompositionString.
	self assert: 'SPTestTrait' equals: spClass classTraitCompositionString.
	
	


]

{ #category : #tests }
SPClassBuilderTest >> testWeakArrayClass [

	| class |
	
	class := SPClassBuilder new
		setClass: WeakArray;
		build.
		
	self assert: #WeakArray equals: class name.
	self assert: #weak equals: class classType.

]
