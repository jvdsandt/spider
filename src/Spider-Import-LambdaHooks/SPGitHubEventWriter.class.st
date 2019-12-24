Class {
	#name : #SPGitHubEventWriter,
	#superclass : #Object,
	#instVars : [
		'writerQueue'
	],
	#category : #'Spider-Import-LambdaHooks'
}

{ #category : #writing }
SPGitHubEventWriter >> write: eventData [

	| request |
	
	request := AWSSQSSendMessageRequest new
		addStringAttribute: 'github-event' value: eventData eventName;
		addStringAttribute: 'github-guid' value: eventData guid;
		body: eventData asSpiderUpdateJson;
		yourself.
	
	writerQueue writeMessage: request
]

{ #category : #accessing }
SPGitHubEventWriter >> writerQueue [
	^ writerQueue
]

{ #category : #accessing }
SPGitHubEventWriter >> writerQueue: anObject [
	writerQueue := anObject
]
