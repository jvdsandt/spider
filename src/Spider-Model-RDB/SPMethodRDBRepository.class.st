Class {
	#name : #SPMethodRDBRepository,
	#superclass : #SPMethodRepository,
	#instVars : [
		'queries'
	],
	#category : #'Spider-Model-RDB-Repos'
}

{ #category : #internal }
SPMethodRDBRepository >> escapeAndLowerLikeParameter: aString [

	^ String streamContents: [ :s |
			aString do: [ :ch |
				( '\_%' includes: ch )
						ifTrue: [ s nextPut: $\; nextPut: ch ]
						ifFalse: [ s nextPut: ch asLowercase ] ] ]
]

{ #category : #queries }
SPMethodRDBRepository >> getMethodById: anId [

	| method |
	
	method := self glorpSession readOneOf: SPMethod where: [ :each | each id = anId ].
	method isNil
		ifTrue: [ self error: 'Method not found' ].
	^ method
]

{ #category : #accessing }
SPMethodRDBRepository >> glorpSession [

	^ context glorpSession
]

{ #category : #queries }
SPMethodRDBRepository >> selectMethodByHash: aBytes ifAbsent: aBlock [

	| method |
	
	method := self glorpSession readOneOf: SPMethod where: [ :each | each sourceHash = aBytes ].
	^ method isNil
			ifTrue: [ aBlock value ]
			ifFalse: [ method ]
]

{ #category : #queries }
SPMethodRDBRepository >> selectorsStaringWith: aString after: lastString max: maxCount [

	| sql statement |

	sql := 'SELECT selector FROM selectors WHERE lower(selector) like $1 AND lower(selector) > $2 ORDER BY lower(selector) LIMIT $3'.
	statement := queries at: sql ifAbsentPut: [ queries createQuery: sql ].
	
	^ statement query: (Array 
			with: (self escapeAndLowerLikeParameter: aString), '%'
			with: (self escapeAndLowerLikeParameter: (lastString ifNil: [ ' ' ]))
			with: maxCount)
]

{ #category : #queries }
SPMethodRDBRepository >> sendersOf: aSelector [

	| query |
	
	query := Query 
		read: SPMethod 
		where: [ :m | m selectorRefs anySatisfy: [ :ref | ref selector = aSelector ] ].
		
	^ self glorpSession execute: query
]

{ #category : #queries }
SPMethodRDBRepository >> variablesStaringWith: aString after: lastString max: maxCount [

	| sql statement |

	sql := 'SELECT variable FROM variables WHERE lower(variable) like $1 AND lower(variable) > $2 ORDER BY lower(variable) LIMIT $3'.
	statement := queries at: sql ifAbsentPut: [ queries createQuery: sql ].
	
	^ statement query: (Array 
			with: (self escapeAndLowerLikeParameter: aString), '%'
			with: (self escapeAndLowerLikeParameter: (lastString ifNil: [ ' ' ]))
			with: maxCount)
]
