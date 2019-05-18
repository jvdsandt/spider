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
