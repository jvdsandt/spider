Extension { #name : #SPGlorpClass }

{ #category : #'*Spider-Model-Ring2' }
SPGlorpClass >> ring2ClassIn: aCategory [

	self isSpiderTrait
		ifTrue: [ ^ SPRing2Trait new initWith: self category: aCategory ].
	self isSpiderClass 
		ifTrue: [ ^ SPRing2Class new initWith: self category: aCategory ].
		
	self error: 'not a class or trait'
]
