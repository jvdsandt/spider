Class {
	#name : #SPGitHubEventData,
	#superclass : #Object,
	#instVars : [
		'eventName',
		'guid',
		'data',
		'signature'
	],
	#category : #'Spider-Import-LambdaHooks'
}

{ #category : #converting }
SPGitHubEventData >> asSpiderUpdateJson [

	| input msg |
	
	input := NeoJSONReader fromString: self data.
	
	msg := OrderedDictionary new.
	#( 'ref' 'after' 'repository' 'pusher' 'sender' ) do: [ :each |
		input at: each ifPresent: [ :value | msg at: each put: value ] ].

	^ NeoJSONWriter toString: msg
]

{ #category : #accessing }
SPGitHubEventData >> data [
	^ data
]

{ #category : #accessing }
SPGitHubEventData >> eventName [
	^ eventName
]

{ #category : #accessing }
SPGitHubEventData >> guid [
	^ guid
]

{ #category : #testing }
SPGitHubEventData >> isSignatureCorrect [

	^ true  "todo"
]

{ #category : #initialization }
SPGitHubEventData >> setEventName: aName guid: anId data: aString signature: aSignature [

	eventName := aName.
	guid := anId.
	data := aString.
	signature := aSignature.
]

{ #category : #accessing }
SPGitHubEventData >> signature [
	^ signature
]
