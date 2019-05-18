Class {
	#name : #SGMethodBuilderTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #tests }
SGMethodBuilderTest >> methodBuilder [ 

	^ SPMethodBuilder new
]

{ #category : #tests }
SGMethodBuilderTest >> testCollectionMethods [

	Collection methods do: [ :each |
		self testCompiledMethod: each ]
]

{ #category : #tests }
SGMethodBuilderTest >> testCompiledMethod: aCM [

	| method |
	
	method := self methodBuilder 
		setCompiledMethod: aCM;
		build.
		
	self assert: aCM selector equals: method selector.
	
	^method
]

{ #category : #tests }
SGMethodBuilderTest >> testMethod [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
	^nil';
		build.
	
	self assert: method selector equals: #hello.
	self assert: method messages equals: #().

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodHash [

	| builder |
	
	builder := self methodBuilder
		setSource: 'hello
	self theMessage';
		yourself.
	
	self assert: builder sourceBytes equals: #[104 101 108 108 111 10 9 115 101 108 102 32 116 104 101 77 101 115 115 97 103 101].
	self assert: builder sourceHash equals: #[227 188 167 20 226 43 213 7 33 130 254 254 162 145 249 175 165 28 9 103]
]

{ #category : #tests }
SGMethodBuilderTest >> testMethodHash2 [

	| builder |
	
	builder := self methodBuilder
		setSource: '	hello', String crlf, '	self a.', String cr, '	self b 	 ';
		yourself.
	
	self assert: builder sourceBytes equals: #[104 101 108 108 111 10 9 115 101 108 102 32 97 46 10 9 115 101 108 102 32 98].
	self assert: builder sourceHash equals: #[11 205 205 59 227 149 180 222 102 235 44 2 51 138 240 221 119 232 62 163]
]

{ #category : #tests }
SGMethodBuilderTest >> testMethodSource [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
	^nil';
		build.
	
	self assert: method source equals: 'hello', String lf,'	^nil'.
	self assert: method sourceHash equals: #[216 226 164 33 135 58 170 2 174 244 96 206 53 95 202 35 69 166 35 89].
	
	method := self methodBuilder
		setSource: 'hello
	^nil  		 ';
		build.
	
	self assert: method source equals: 'hello', String lf,'	^nil'.
	self assert: method sourceHash equals: #[216 226 164 33 135 58 170 2 174 244 96 206 53 95 202 35 69 166 35 89].
]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithError [

	| method |
	
	method := self methodBuilder
		setSource: 'at: aKey append: aValue
	self at: aKey append: aValue separator: $';
		build.
	
	self assert: method selector equals: #at:append:.
	self assert: method messages equals: #( at:append:separator: ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithGlobals [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
		(X ifNil: [ Y ]) doStuff.
	^nil';
		build.
	
	self assert: method selector equals: #hello.
	self assert: method messages sorted equals: #( doStuff ifNil: ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithMessage [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
	self theMessage';
		build.
	
	self assert: method selector equals: #hello.
	self assert: method messages equals: #( theMessage ).
	self assert: method messagesToSelf equals: #( theMessage ).
	self assert: method messagesToSuper equals: #( ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithMessage2 [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
	super a; b; c';
		build.
	
	self assert: method selector equals: #hello.
	self assert: method messages equals: #( a b c ).
	self assert: method messagesToSelf equals: #( ).
	self assert: method messagesToSuper equals: #( a b c ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithPoolVariable [

	| method |
	
	method := self methodBuilder
		setSource: 'initialize
	"self initialize"
	
	VariableInPoolDefiner2 := 33.
	Author := ''NotDucasse''.';
		build.
	
	self assert: method selector equals: #initialize.
	self assert: method variables sorted equals: #( Author VariableInPoolDefiner2 ).
	self assert: method variablesWritten sorted equals: #( Author VariableInPoolDefiner2 ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithPragma [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
	<myPrag>
	self theMessage';
		build.
	
	self assert: method pragmas equals: #( myPrag ).
	self assert: method messages equals: #( theMessage ).
	self assert: method messagesToSelf equals: #( theMessage ).	
	self assert: method messagesToSuper equals: #( ).	

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithUnusedVariable [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
	a';
		build.
	
	self assert: method selector equals: #hello.
	self assert: method variables equals: #( a ).
	self assert: method variablesRead equals: #( ).
	self assert: method variablesWritten equals: #( ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithVariableWrite [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
	a := 1';
		build.
	
	self assert: method selector equals: #hello.
	self assert: method variables equals: #( a ).
	self assert: method variablesRead equals: #( ).
	self assert: method variablesWritten equals: #( a ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithVariables [

	| method |
	
	method := self methodBuilder
		setSource: 'hello
	a b';
		build.
	
	self assert: method selector equals: #hello.
	self assert: method variables equals: #( a ).
	self assert: method variablesRead equals: #( a ).
	self assert: method variablesWritten equals: #( ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithVariables2 [

	| method |
	
	method := self methodBuilder
		setSource: 'hello: a and: b
	| c d |
	a. b. c. d. e. f.';
		build.
	
	self assert: method selector equals: #hello:and:.
	self assert: method variables equals: #( e f ).

]

{ #category : #tests }
SGMethodBuilderTest >> testMethodWithVariables3 [

	| method |
	
	method := self methodBuilder
		setSource: 'hello: a and: b
	| c d |
	[ :e :f | k. l. m. a. d. f. ]';
		build.
	
	self assert: method selector equals: #hello:and:.
	self assert: method variables equals: #( k l m ).
	self assert: method variablesRead equals: #( ).
	self assert: method variablesWritten equals: #( ).

]

{ #category : #tests }
SGMethodBuilderTest >> testSingleLine [

	| method |
	
	method := self methodBuilder
		setSource: 'hello ^self hi';
		build.
	
	self assert: method selector equals: #hello.
	self assert: method messages equals: #( hi ).

]
