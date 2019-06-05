Class {
	#name : #SPBehaviorTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #running }
SPBehaviorTest >> createMethodFromSource: aString [

	^ SPMethodBuilder new
		setSource: aString;
		build
]

{ #category : #tests }
SPBehaviorTest >> testClassWithClassVar [

	| spiderClass |
	
	spiderClass := SPGlorpClass className: #Hello 
		classType: #special 
		superclassName: #Object 
		variableRefs: (Array with: (SPClassToVariableRef classVar: #MyVar))
		methodRefs: #()
		comment: 'No comment'.
		
	self assert: #( MyVar ) equals: spiderClass classVarNames.

	self assert: spiderClass hashSignature equals: 'Hello
Object
40 special

61 MyVar

No comment
' withUnixLineEndings
]

{ #category : #tests }
SPBehaviorTest >> testClassWithPoolDictionary [

	| spiderClass |
	
	spiderClass := SPGlorpClass className: #Hello 
		classType: #normal 
		superclassName: #Object 
		variableRefs: (Array with: (SPClassToVariableRef poolVar: #MyPool))
		methodRefs: #()
		comment: 'No comment'.
		
	self assert: #( MyPool ) equals: spiderClass poolDictionaryNames.

	self assert: spiderClass hashSignature equals: 'Hello
Object
40 normal

63 MyPool

No comment
' withUnixLineEndings
]

{ #category : #tests }
SPBehaviorTest >> testClassWithsVars [

	| spiderClass |
	
	spiderClass := SPGlorpClass className: #MyClass 
		classType: #normal
		superclassName: #Object
		variableRefs: (Array with: (SPClassToVariableRef instanceVar: #myVar)) 
		methodRefs: #()
		comment: 'Nothing special.'.
		
	self assert: spiderClass classHash equals: #[103 219 133 183 253 57 181 208 51 137 249 93 3 125 48 101 187 15 141 121]
]

{ #category : #tests }
SPBehaviorTest >> testSimpleClass [

	| m1 spiderClass |
	
	m1 := self createMethodFromSource: 'hello  ^ #HelloWorld'.
	
	spiderClass := SPGlorpClass className: #Hello 
		classType: #normal 
		superclassName: #Object 
		variableRefs: #()
		methodRefs: (Array with: (SPClassToMethodRef instanceMethod: m1 category: 'accessing')) 
		comment: 'No comment'.
		
	self assert: spiderClass name equals: #Hello.
	self assert: spiderClass comment equals: 'No comment'.
	self assert: spiderClass superclassName equals: #Object.
	self assert: spiderClass instanceSelectors equals: #( hello ).
	self assert: spiderClass classSelectors equals: #( ).
	self assert: spiderClass poolDictionaryNames isEmpty.

	self assert: spiderClass hashSignature equals: 'Hello
Object
40 normal


50 4c3fd161c5550db697d4421ccd63c937ae3bcb47 accessing
No comment
' withUnixLineEndings
]

{ #category : #tests }
SPBehaviorTest >> testSimpleClassExtension [

	| m1 m2 spiderClass |
	
	m1 := self createMethodFromSource: 'hello  ^ #HelloWorld'.
	m2 := self createMethodFromSource: 'isAbstract 	^ false'.
	
	spiderClass := SPGlorpClass extensionName: #Hello
		methodRefs: (Array
			with: (SPClassToMethodRef instanceMethod: m1 category: 'accessing')
			with: (SPClassToMethodRef classMethod: m2 category: 'testing'))
		comment: nil.
		
	self assert: spiderClass hashSignature equals: 'Hello

41 


50 4c3fd161c5550db697d4421ccd63c937ae3bcb47 accessing
51 0264452a76964f8f2e678a1e1bfadc16c83cbec8 testing
' withUnixLineEndings
]

{ #category : #tests }
SPBehaviorTest >> testSimpleTrait [

	| m1 spiderClass |
	
	m1 := self createMethodFromSource: 'hello  ^ #HelloWorld'.
	
	spiderClass := SPGlorpClass traitName: #Hello 
		variableRefs: #()
		methodRefs: (Array with: (SPClassToMethodRef instanceMethod: m1 category: 'accessing'))
		traitComposition: nil
		classTraitComposition: nil
		comment: 'No comment'.
		
	self assert: spiderClass name equals: #Hello.
	self assert: spiderClass comment equals: 'No comment'.
	self assert: spiderClass instanceSelectors equals: #( hello ).
	self assert: spiderClass classSelectors equals: #( ).

	self assert: spiderClass hashSignature equals: 'Hello

42 


50 4c3fd161c5550db697d4421ccd63c937ae3bcb47 accessing
No comment
' withUnixLineEndings
]
