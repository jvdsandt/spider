Class {
	#name : #SPAPIGatewayGitHubHooksHandler,
	#superclass : #AWSLambdaAPIGatewayHandler,
	#instVars : [
		'eventWriter'
	],
	#category : #'Spider-Import-LambdaHooks'
}

{ #category : #responses }
SPAPIGatewayGitHubHooksHandler >> badRequestResponse: aMessage [

	^ AWSLambdaAPIProxyResponse new
			statusCode: 400;
			bodyJson: (SmallDictionary new
				at: #code put: 400;
				at: #message put: aMessage;
				yourself);
			yourself
]

{ #category : #accessing }
SPAPIGatewayGitHubHooksHandler >> eventWriter [
	^ eventWriter
]

{ #category : #invoking }
SPAPIGatewayGitHubHooksHandler >> handleAPIRequest: apiRequest [

	| githubEvent guid signature body |
	
	self isInitialized 
		ifFalse: [ 
			self initEventWriter.
			self isInitialized 
				ifFalse: [ ^ self serverErrorResponse: 'Initialization failed' ] ].
			
	apiRequest isHttpGetMethod
		ifTrue: [ ^ self handleGetInfo: apiRequest ].
	
	githubEvent := apiRequest headers at: 'X-GitHub-Event' 
		ifAbsent: [ ^ self badRequestResponse: 'X-GitHub-Event header missing' ].
	guid := apiRequest headers at: 'X-GitHub-Delivery'
		ifAbsent: [ ^ self badRequestResponse: 'X-GitHub-Delivery header missing' ].
	signature := apiRequest headers at: 'X-Hub-Signature'
		ifAbsent: [ ^ self badRequestResponse: 'X-Hub-Signature header missing' ].
	body := apiRequest bodyDecoded.
	
	^ self handleGitHubEvent: (SPGitHubEventData new
			setEventName: githubEvent guid: guid data: body signature: signature;
			yourself)
]

{ #category : #invoking }
SPAPIGatewayGitHubHooksHandler >> handleGetInfo: apiRequest [

	^ OrderedDictionary new
			at: 'image' put: SystemVersion current imageVersionString;
			at: 'startedAt' put: self environment startedAt asString;
			at: 'invocationCount' put: self environment invocationCount;
			at: 'invocationErrorCount' put: self environment invocationErrorCount;
			yourself
]

{ #category : #invoking }
SPAPIGatewayGitHubHooksHandler >> handleGitHubEvent: eventData [

	eventData isSignatureCorrect 
		ifFalse: [ ^ self badRequestResponse: 'Invalid signature' ].

	self eventWriter write: eventData.
	
	^self okResponse
]

{ #category : #initialization }
SPAPIGatewayGitHubHooksHandler >> initEventWriter [

	| queueUrl sqsservice sqswriter |

	queueUrl := self environment getEnv: 'GITHUB_EVENTS_QUEUE_URL'.
	queueUrl isEmptyOrNil 
		ifTrue: [ 
			self logStream addEventMessage: 'ERROR - GITHUB_EVENTS_QUEUE_URL environment variable not set'.
			^ self ].

	sqsservice := AWSSQService newWithCredentials: self environment awsCredentials 
			region: self environment region.
	sqswriter := AWSSQSWriter service: sqsservice queueUrl: queueUrl.

	eventWriter := SPGitHubEventWriter new
		writerQueue: sqswriter;
		yourself
]

{ #category : #testing }
SPAPIGatewayGitHubHooksHandler >> isInitialized [ 

	^ eventWriter notNil
]

{ #category : #responses }
SPAPIGatewayGitHubHooksHandler >> okResponse [

	^ AWSLambdaAPIProxyResponse new
			statusCode: 200;
			bodyJson: (SmallDictionary new
				at: #code put: 200;
				at: #message put: 'OK';
				yourself);
			yourself
]

{ #category : #responses }
SPAPIGatewayGitHubHooksHandler >> serverErrorResponse: aMessage [

	^ AWSLambdaAPIProxyResponse new
			statusCode: 500;
			bodyJson: (SmallDictionary new
				at: #code put: 500;
				at: #message put: aMessage;
				yourself);
			yourself
]
