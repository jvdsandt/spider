Class {
	#name : #SPRouteBuilder,
	#superclass : #WARouteBuilder,
	#category : #'Spider-Web-Core-Seaside'
}

{ #category : #initialization }
SPRouteBuilder class >> initialize [
	configuration := IdentitySet new.
	(Pragma allNamed: #configuration in: WARouteBuilder)
		do: [ :pragma | configuration add: pragma method selector ]
]

{ #category : #private }
SPRouteBuilder >> createComplexRoute [
	^ SPPathRoute
		method: method selector: compiled selector pattern: path
		arguments: (GRPlatform current argumentNamesOf: compiled)
		produces: produces
		consumes: (self createMimeTypeMatch: consumes)
]
