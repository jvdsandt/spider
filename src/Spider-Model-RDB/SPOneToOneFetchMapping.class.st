Class {
	#name : #SPOneToOneFetchMapping,
	#superclass : #OneToOneMapping,
	#category : #'Spider-Model-RDB-Glorp'
}

{ #category : #mapping }
SPOneToOneFetchMapping >> buildQuery [ 

	| q |
	
	q := super buildQuery.
	q alsoFetch: [ :r | r spiderClass ].
	^  q
]
