Class {
	#name : #SPClassToMethodRefTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #tests }
SPClassToMethodRefTest >> testHashes [

	| method ref str |
	
	method := SPMethodBuilder new
		setSource: 'sayHello
		^ #hi';
		build.

	ref := SPClassToMethodRef instanceMethod: method category: 'actions'.
	str := String streamContents: [ :s | ref printHashSignatureOn: s ].
	self assert: '50 29d0778e24435760ab3657d2d30c240146a35593 actions' equals: str.
	
	ref := SPClassToMethodRef instanceMethod: method category: nil.
	str := String streamContents: [ :s | ref printHashSignatureOn: s ].
	self assert: '50 29d0778e24435760ab3657d2d30c240146a35593' equals: str.
	
	ref := SPClassToMethodRef classMethod: method category: nil.
	str := String streamContents: [ :s | ref printHashSignatureOn: s ].
	self assert: '51 29d0778e24435760ab3657d2d30c240146a35593' equals: str.

	ref := SPClassToMethodRef classMethod: method category: 'actions'.
	str := String streamContents: [ :s | ref printHashSignatureOn: s ].
	self assert: '51 29d0778e24435760ab3657d2d30c240146a35593 actions' equals: str.
]
