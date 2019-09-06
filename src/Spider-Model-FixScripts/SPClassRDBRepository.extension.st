Extension { #name : #SPClassRDBRepository }

{ #category : #'*Spider-Model-FixScripts' }
SPClassRDBRepository >> updateCommentAndHash: aSpiderClass [

	| otherClass |
	
	otherClass := self getClassByHash: aSpiderClass classHash ifAbsent: [ nil ].
	(otherClass notNil and: [ otherClass ~= aSpiderClass ])
		ifTrue: [ self error: 'Classhash no longer unique' ].

	otherClass notNil
		ifTrue: [ 
			self replaceRefsTo: aSpiderClass with: otherClass ]
		ifFalse: [ 
			self updateCommentAndHashQuery execute: (Array 
					with: aSpiderClass id 
					with: aSpiderClass classHash
					with: aSpiderClass comment) ]
]
