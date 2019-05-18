Class {
	#name : #SPGlorpClassToMethodRefTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #tests }
SPGlorpClassToMethodRefTest >> testHashes [

	| method ref str |
	
	method := SPMethodBuilder new
		setSource: 'sayHello
		^ #hi';
		build.

	ref := SPGlorpClassToMethodRef instanceMethod: method category: 'actions'.
	str := String streamContents: [ :s | ref printHashSignatureOn: s ].
	self assert: '50 29d0778e24435760ab3657d2d30c240146a35593 actions' equals: str.
	
	ref := SPGlorpClassToMethodRef instanceMethod: method category: nil.
	str := String streamContents: [ :s | ref printHashSignatureOn: s ].
	self assert: '50 29d0778e24435760ab3657d2d30c240146a35593' equals: str.
	
	ref := SPGlorpClassToMethodRef classMethod: method category: nil.
	str := String streamContents: [ :s | ref printHashSignatureOn: s ].
	self assert: '51 29d0778e24435760ab3657d2d30c240146a35593' equals: str.

	ref := SPGlorpClassToMethodRef classMethod: method category: 'actions'.
	str := String streamContents: [ :s | ref printHashSignatureOn: s ].
	self assert: '51 29d0778e24435760ab3657d2d30c240146a35593 actions' equals: str.
]
