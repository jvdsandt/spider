Extension { #name : #SPPackage }

{ #category : #'*Spider-Model-Ring2' }
SPPackage >> ring2ClassNamed: aName [

	| ref |
	
	ref := self classRefNamed: aName.
	ref isSpiderTrait
		ifTrue: [ ^ SPRing2Trait new initWith: ref spiderClass category: (ref fullCategoryIn: self) ].
	ref isSpiderClass 
		ifTrue: [ ^ SPRing2Class new initWith: ref spiderClass category: (ref fullCategoryIn: self) ].
		
	self error: 'not a class or trait'
]
