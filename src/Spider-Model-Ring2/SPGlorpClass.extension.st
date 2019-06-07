Extension { #name : #SPGlorpClass }

{ #category : #'*Spider-Model-Ring2' }
SPGlorpClass >> asRingMinimalDefinitionIn: anRGEnvironment [

	self isSpiderTrait 
		ifTrue: [ 
			^ anRGEnvironment backend
					definitionFor: self
					ifAbsentRegister: [ RGTrait named: self name parent: anRGEnvironment ] ].

	self isSpiderClass 
		ifTrue: [ 
			^ anRGEnvironment backend
					definitionFor: self
					ifAbsentRegister: [ RGClass named: self name parent: anRGEnvironment ] ].
				
	self error: 'Cannot create Ring definition'
]
