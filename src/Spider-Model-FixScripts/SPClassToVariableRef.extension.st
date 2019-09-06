Extension { #name : #SPClassToVariableRef }

{ #category : #'*Spider-Model-FixScripts' }
SPClassToVariableRef >> fixSlotVariable [

	variable first = $#
		ifTrue: [ 
			(variable indexOfSubCollection: '=>') > 0
				ifTrue: [ 
					expression := variable asString.
					variable := (variable readStream next; upToAll: '=>') trimBoth: [ :ch | ch isSeparator or: [ ch = $' ] ] ]
				ifFalse: [ 
					variable := variable allButFirst ].
			variable := variable asSymbol ]
]
