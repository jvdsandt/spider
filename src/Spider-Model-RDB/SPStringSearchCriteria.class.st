Class {
	#name : #SPStringSearchCriteria,
	#superclass : #Object,
	#instVars : [
		'term',
		'caseSensitive',
		'wildcardBefore',
		'wildcardAfter',
		'after'
	],
	#category : #'Spider-Model-RDB-Util'
}

{ #category : #accessing }
SPStringSearchCriteria >> after [
	^ after
]

{ #category : #accessing }
SPStringSearchCriteria >> after: anObject [
	after := anObject
]

{ #category : #converting }
SPStringSearchCriteria >> asWhereNameBlock [

	| param |

	self isExact 
		ifTrue: [ ^ [ :e | e name = self term ] ].
		
	param := self termEscaped.
	self wildcardBefore 
		ifTrue: [ param := '%', param ].
	self wildcardAfter 
		ifTrue: [ param := param, '%' ].
	^ self caseSensitive 
			ifTrue: [ 
				self after isEmptyOrNil 	
					ifTrue: [ [ :e | e name like: param ] ]
					ifFalse: [ [ :e | (e name like: param) AND: [ e name > self after ] ] ] ]
			ifFalse: [ 
				self after isEmptyOrNil 
					ifTrue: [ [ :e | e name ilike: param ] ]
					ifFalse: [ [ :e | (e name ilike: param) AND: [ e name > self after ] ] ] ]
]

{ #category : #converting }
SPStringSearchCriteria >> asWhereSelectorBlock [

	| param |

	self isExact 
		ifTrue: [ ^ [ :e | e selector = self term ] ].
		
	param := self termEscaped.
	self wildcardBefore 
		ifTrue: [ param := '%', param ].
	self wildcardAfter 
		ifTrue: [ param := param, '%' ].
	^ self caseSensitive 
			ifTrue: [ 
				self after isEmptyOrNil 	
					ifTrue: [ [ :e | e selector like: param ] ]
					ifFalse: [ [ :e | (e selector like: param) AND: [ e selector > self after ] ] ] ]
			ifFalse: [ 
				self after isEmptyOrNil 
					ifTrue: [ [ :e | e selector ilike: param ] ]
					ifFalse: [ [ :e | (e selector ilike: param) AND: [ e selector > self after ] ] ] ]
]

{ #category : #converting }
SPStringSearchCriteria >> asWhereUrlBlock [

	| param |

	self isExact 
		ifTrue: [ ^ [ :e | e url = self term ] ].
		
	param := self termEscaped.
	self wildcardBefore 
		ifTrue: [ param := '%', param ].
	self wildcardAfter 
		ifTrue: [ param := param, '%' ].
	^ self caseSensitive 
			ifTrue: [ 
				self after isEmptyOrNil 	
					ifTrue: [ [ :e | e url like: param ] ]
					ifFalse: [ [ :e | (e url like: param) AND: [ e url > self after ] ] ] ]
			ifFalse: [ 
				self after isEmptyOrNil 
					ifTrue: [ [ :e | e url ilike: param ] ]
					ifFalse: [ [ :e | (e url ilike: param) AND: [ e url > self after ] ] ] ]
]

{ #category : #accessing }
SPStringSearchCriteria >> caseSensitive [
	^ caseSensitive
]

{ #category : #accessing }
SPStringSearchCriteria >> caseSensitive: anObject [
	caseSensitive := anObject
]

{ #category : #testing }
SPStringSearchCriteria >> hasValidTerm [

	^ self term notNil and: [ 
		self term trimmed notEmpty and: [
			self term size < 3
				ifTrue: [ self term anySatisfy: [ :ch | ch isLetter not ] ]
				ifFalse: [ true ] ] ]
]

{ #category : #initialization }
SPStringSearchCriteria >> initialize [

	super initialize.
	term := ''.
	caseSensitive := false.
	wildcardBefore := false.
	wildcardAfter := true
]

{ #category : #testing }
SPStringSearchCriteria >> isExact [

	^ self caseSensitive and: [ 
		self wildcardBefore not and: [
			self wildcardAfter not ] ]
]

{ #category : #accessing }
SPStringSearchCriteria >> term [
	^ term
]

{ #category : #accessing }
SPStringSearchCriteria >> term: anObject [
	term := anObject
]

{ #category : #accessing }
SPStringSearchCriteria >> termEscaped [
	"Add the escape character $\ before the special characters in Postgres like queries"

	^ String streamContents: [ :s |
			self term do: [ :each |
				( '\_%' includes: each )
					ifTrue: [ s nextPut: $\ ].
				s nextPut: each ] ]
]

{ #category : #accessing }
SPStringSearchCriteria >> wildcardAfter [
	^ wildcardAfter
]

{ #category : #accessing }
SPStringSearchCriteria >> wildcardAfter: anObject [
	wildcardAfter := anObject
]

{ #category : #accessing }
SPStringSearchCriteria >> wildcardBefore [
	^ wildcardBefore
]

{ #category : #accessing }
SPStringSearchCriteria >> wildcardBefore: anObject [
	wildcardBefore := anObject
]
