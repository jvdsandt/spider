Extension { #name : #SPGlorpClass }

{ #category : #'*Spider-Model-FixScripts' }
SPGlorpClass >> fixSlotVariableRefs [

	self variableRefs do: [ :each | each fixSlotVariable ]
]

{ #category : #'*Spider-Model-FixScripts' }
SPGlorpClass >> updateComment: newComment [

	comment := newComment.
	self initClassHash
	
]
