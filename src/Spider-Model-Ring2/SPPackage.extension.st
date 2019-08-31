Extension { #name : #SPPackage }

{ #category : #'*Spider-Model-Ring2' }
SPPackage >> ring2ClassNamed: aName [

	| ref |
	
	ref := self classRefNamed: aName.
	^ ref spiderClass ring2ClassIn: (ref fullCategoryIn: self)
]
