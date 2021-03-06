Class {
	#name : #SPClassBuilderTonelTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #running }
SPClassBuilderTonelTest >> sampleClass [

	| contents |
	
	contents := '"
I am P3Error.

I get signalled when something goes wrong in using P3Client, either an error inside the driver itself, or an error signalled by the PostgreSQL database backend server.
"
Class {
	#name : #P3Error,
	#superclass : #Error,
	#instVars : [
		''info''
	],
	#category : #P3
}

{ #category : #accessing }
P3Error >> description [
	"Return a textual description of the exception."

	^ String streamContents: [ :stream | | mt |
		stream << self class name << '' PostgreSQL ''.
		(mt := self messageText) isEmptyOrNil
			ifFalse: [ stream << mt ] ]
]

{ #category : #accessing }
P3Error >> info [
	^ info
]

{ #category : #accessing }
P3Error >> info: anObject [
	info := anObject
]
'.

	^ self string: contents asFileRefNamed: 'P3Error.class.st'
]

{ #category : #running }
SPClassBuilderTonelTest >> sampleClassWithSlots [

	| contents |
	
	contents := '"
A SlotExampleMovie is an example class to demonstrate the workings of relation slots.
"
Class {
	#name : #SlotExampleMovie,
	#superclass : #Object,
	#instVars : [
		''#name'',
		''#director => ToOneRelationSlot inverse: #directedMovies inClass: #SlotExamplePerson'',
		''#actors => ToManyRelationSlot inverse: #actedInMovies inClass: #SlotExamplePerson''
	],
	#category : #''Slot-Tests-Examples - Associations''
}'.

	^ self string: contents asFileRefNamed: 'SlotExampleMovie.class.st'
]

{ #category : #running }
SPClassBuilderTonelTest >> sampleClassWithTraits [

	| contents |
	
	contents := 'Class {
	#name : #FamixJavaClass,
	#superclass : #FamixJavaType,
	#traits : ''FamixTClass + FamixTLCOMMetrics + FamixTWithExceptions'',
	#classTraits : ''FamixTClass classTrait + FamixTLCOMMetrics classTrait + FamixTWithExceptions classTrait'',
	#category : #''Famix-Java-Entities-Entities''
}
'.

	^ self string: contents asFileRefNamed: 'FamixJavaClass.class.st'
]

{ #category : #running }
SPClassBuilderTonelTest >> sampleExtension [

	| contents |
	
	contents := 'Extension { #name : #ByteArray }

{ #category : #''*P3'' }
ByteArray >> printAsP3TextOn: aStream [
	"Append to the argument aStream a representation of the receiver in 
	Postgres text format"

	| v map |

	aStream
		nextPut: $\;
		nextPut: $x.
	map := ''0123456789abcdef''.
	1 to: self size do: [ :i |
		v := self at: i.
		aStream 
			nextPut: (map at: (v bitShift: -4) + 1);
			nextPut: (map at: (v bitAnd: 15) + 1) ]
]
'.

	^ self string: contents asFileRefNamed: 'ByteArray.extension.st'
]

{ #category : #running }
SPClassBuilderTonelTest >> sampleTraitWithSlots [

	| contents |
	
	contents := '"
FAMIXAssociation is an abstract superclass for relationships between Famix named entities. 
"
Trait {
	#name : #FamixTAssociation,
	#instVars : [
		''#next => FMOne type: #FamixTAssociation opposite: #previous'',
		''#previous => FMOne type: #FamixTAssociation opposite: #next''
	],
	#category : #''Famix-Traits-Association''
}
'.

	^ self string: contents asFileRefNamed: 'FamixTAssociation.trait.st'
]

{ #category : #running }
SPClassBuilderTonelTest >> string: aString asFileRefNamed: fileName [

	| ref |

	ref := FileSystem memory root / fileName.
	ref writeStreamDo: [ :s | s nextPutAll: aString ].
	^ ref
]

{ #category : #tests }
SPClassBuilderTonelTest >> testSampleClass [

	| class |
	
	class := SPClassBuilder new
		setTonelFileReference: self sampleClass;
		build.

	self assert: class name equals: #P3Error. 
	self assert: class superclassName equals: #Error. 
	self assert: class isSpiderClass.
	self assert: class instanceSelectors sorted equals: #( description info info: ).
	self assert: class instanceVarNames equals: #( info ).
	self assert: class classVarNames equals: #().
	self assert: class classSelectors equals: #().	
	
	self assert: (class instanceVarRefNamed: #info) expressionOrNil equals: nil.
	self assert: (class instanceVarRefNamed: #info) expression equals: '#info'.

]

{ #category : #tests }
SPClassBuilderTonelTest >> testSampleClassEquals [

	| class1 class2 |
	
	class1 := SPClassBuilder new
		setTonelFileReference: self sampleClass;
		build.

	class2 := SPClassBuilder new
		setTonelFileReference: self sampleClass;
		build.

	self assert: class1 classHash equals: class2 classHash.
	self assert: class1 hash equals: class2 hash.
	self assert: class1 equals: class2.

]

{ #category : #tests }
SPClassBuilderTonelTest >> testSampleClassWithSlots [

	| class |
	
	class := SPClassBuilder new
		setTonelFileReference: self sampleClassWithSlots;
		build.

	self assert: class name equals: #SlotExampleMovie. 
	self assert: class superclassName equals: #Object. 
	self assert: class isSpiderClass.
	self assert: class instanceVarNames equals: #( name director actors ).
	self assert: class classVarNames equals: #().

	self assert: (class instanceVarRefNamed: #name) expressionOrNil equals: nil.
	self assert: (class instanceVarRefNamed: #director) expression 
		equals: '#director => ToOneRelationSlot inverse: #directedMovies inClass: #SlotExamplePerson'.
	self assert: (class instanceVarRefNamed: #actors) expression 
		equals: '#actors => ToManyRelationSlot inverse: #actedInMovies inClass: #SlotExamplePerson'.
]

{ #category : #tests }
SPClassBuilderTonelTest >> testSampleClassWithTraits [

	| class |
	
	class := SPClassBuilder new
		setTonelFileReference: self sampleClassWithTraits;
		build.

	self assert: class name equals: #FamixJavaClass. 
	self assert: class superclassName equals: #FamixJavaType. 
	self assert: class isSpiderClass.
	
	self assert: class traitCompositionString 
		equals: 'FamixTClass + FamixTLCOMMetrics + FamixTWithExceptions'.
	self assert: class classTraitCompositionString 
		equals: 'FamixTClass classTrait + FamixTLCOMMetrics classTrait + FamixTWithExceptions classTrait'.

]

{ #category : #tests }
SPClassBuilderTonelTest >> testSampleExtension [

	| classExt |
	
	classExt := SPClassExtensionBuilder new
		setTonelFileReference: self sampleExtension;
		build.

	self assert: classExt name equals: #ByteArray. 
	self assert: classExt isSpiderClassExtension.
	self assert: classExt instanceSelectors equals: #( printAsP3TextOn: ).
	self assert: classExt classSelectors equals: #().	
]

{ #category : #tests }
SPClassBuilderTonelTest >> testSampleExtensionEquals [

	| classExt1 classExt2 |
	
	classExt1 := SPClassExtensionBuilder new
		setTonelFileReference: self sampleExtension;
		build.

	classExt2 := SPClassExtensionBuilder new
		setTonelFileReference: self sampleExtension;
		build.

	self assert: classExt1 classHash equals: classExt2 classHash.
	self assert: classExt1 hash equals: classExt2 hash.
	self assert: classExt1 equals: classExt2.

]

{ #category : #tests }
SPClassBuilderTonelTest >> testSampleTraitWithSlots [

	| trait |
	
	trait := SPClassBuilder new
		setTonelFileReference: self sampleTraitWithSlots;
		build.

	self assert: trait name equals: #FamixTAssociation. 
	self assert: trait isSpiderTrait.
	self assert: trait instanceVarNames equals: #( next previous ).
	self assert: trait traitCompositionString isNil.

	self assert: (trait instanceVarRefNamed: #next) expression 
		equals: '#next => FMOne type: #FamixTAssociation opposite: #previous'.
	self assert: (trait instanceVarRefNamed: #previous) expression 
		equals: '#previous => FMOne type: #FamixTAssociation opposite: #next'.
]
