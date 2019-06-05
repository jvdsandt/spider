Class {
	#name : #SPOneToOneFetchMapping,
	#superclass : #OneToOneMapping,
	#category : #'Spider-Model-RDB-Glorp'
}

{ #category : #mapping }
SPOneToOneFetchMapping >> buildQuery [ 

	query := super buildQuery.
	query alsoFetch: [ :r | r spiderClass ].
	^ query
]
