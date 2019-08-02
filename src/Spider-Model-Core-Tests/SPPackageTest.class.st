Class {
	#name : #SPPackageTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #running }
SPPackageTest >> createSampleClass: aName [

	^ SPClassBuilder new
			name: aName;
			build
]

{ #category : #running }
SPPackageTest >> testWithClass [

	| p pc c |
	
	p := SPPackage name: 'P1'
			classRefs: (Array 
				with: (SPPackageToClassRef spiderClass: (self createSampleClass: #C1))
				with: (SPPackageToClassRef spiderClass: (self createSampleClass: #C2)))
			comment: 'no'.
	
	"Add a class"
	c := self createSampleClass: #C3.		
	pc := p withClass: c in: 'Kernel'.
	self assert: pc classNames equals: #( C1 C2 C3 ).
	self assert: p classNames equals: #( C1 C2 ).

	"Update class category"
	c := self createSampleClass: #C1.		
	pc := p withClass: c in: 'Kernel'.
	self assert: pc classNames equals: #( C1 C2 ).
	self assert: (pc classRefNamed: #C1) category equals: 'Kernel'.
	self assert: (p classRefNamed: #C1) category equals: nil.

	"no-op"
	c := self createSampleClass: #C1.		
	pc := p withClass: c in: nil.
	self assert: pc equals: p.

]
