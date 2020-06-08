Class {
	#name : #SPTextUtils,
	#superclass : #Object,
	#category : #'Spider-Model-Core-Util'
}

{ #category : #utilities }
SPTextUtils class >> messageLineFrom: aCommitMessage [
	"Answer a short single line commit message."
	
	| msg index maxLength |
	
	maxLength := 100.
	msg := aCommitMessage ifNil: [ '' ].
	index := msg indexOf: Character cr.
	index := index > 0
		ifTrue: [ index min: (msg indexOf: Character lf) ]
		ifFalse: [ msg indexOf: Character lf ].
	
	^ (index > maxLength or: [ index = 0 and: [ msg size > maxLength ] ])
			ifTrue: [ (msg copyFrom: 1 to: 97), '...' ]
			ifFalse: [ 
				index > 0
					ifTrue: [ msg copyFrom: 1 to: index-1 ]
					ifFalse: [ msg ] ]
]
