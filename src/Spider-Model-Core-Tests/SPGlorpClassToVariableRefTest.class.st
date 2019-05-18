Class {
	#name : #SPGlorpClassToVariableRefTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #tests }
SPGlorpClassToVariableRefTest >> testExpressionHashes [

	| varRef str |

	varRef := SPGlorpClassToVariableRef instanceVar: #director expression: '#director => ToOneRelationSlot inverse: #dm inClass: #Xyz'.
	
	str := String streamContents: [ :s | varRef printHashSignatureOn: s ].
	self assert: '60 #director => ToOneRelationSlot inverse: #dm inClass: #Xyz' equals: str.

]

{ #category : #tests }
SPGlorpClassToVariableRefTest >> testHashes [

	| str |

	str := String streamContents: [ :s | (SPGlorpClassToVariableRef instanceVar: #ivar) printHashSignatureOn: s ].
	self assert: '60 ivar' equals: str.
	
	str := String streamContents: [ :s | (SPGlorpClassToVariableRef classVar: #Cvar) printHashSignatureOn: s ].
	self assert: '61 Cvar' equals: str.
]
