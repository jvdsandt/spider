Class {
	#name : #SPDebugErrorHandler,
	#superclass : #WAErrorHandler,
	#category : #'Spider-Web-Core-Seaside'
}

{ #category : #actions }
SPDebugErrorHandler >> basicResume: anException [

	"If the user closes the debugger, the process is terminated and the stack unwound.
	There was previously an #ifCurtailed: block around the #open: call above to try to
	catch the process termination so we could display a nice error page but this also
	ended up being called when the user restarted a context in the debugger.
	
	If they Proceed in the debugger, behaviour is platform-dependent. Currently, VW
	should resume the signaling context, so this method will not continue past the call
	to #open:. Squeak currently resumes the context that opened the Debugger, which
	results in the call to #open: returning."

	^ anException isResumable
		ifTrue: [ anException resume ]
		ifFalse: [ self unableToResumeResponse ]
]

{ #category : #'as yet unclassified' }
SPDebugErrorHandler >> debugAndResume: anException [
	self open: anException.

	"If the user closes the debugger, the process is terminated and the stack unwound.
	There was previously an #ifCurtailed: block around the #open: call above to try to
	catch the process termination so we could display a nice error page but this also
	ended up being called when the user restarted a context in the debugger.
	
	If they Proceed in the debugger, behaviour is platform-dependent. Currently, VW
	should resume the signaling context, so this method will not continue past the call
	to #open:. Squeak currently resumes the context that opened the Debugger, which
	results in the call to #open: returning."

	^ self resume: anException
]

{ #category : #actions }
SPDebugErrorHandler >> handleDefault: anException [
	^ self debugAndResume: anException
]

{ #category : #'instance creation' }
SPDebugErrorHandler >> open: anException [ 
	GRPlatform current openDebuggerOn: anException
]

{ #category : #'as yet unclassified' }
SPDebugErrorHandler >> resume: anException [
	self open: anException.

	"If the user closes the debugger, the process is terminated and the stack unwound.
	There was previously an #ifCurtailed: block around the #open: call above to try to
	catch the process termination so we could display a nice error page but this also
	ended up being called when the user restarted a context in the debugger.
	
	If they Proceed in the debugger, behaviour is platform-dependent. Currently, VW
	should resume the signaling context, so this method will not continue past the call
	to #open:. Squeak currently resumes the context that opened the Debugger, which
	results in the call to #open: returning."

	^ self basicResume: anException
]

{ #category : #'as yet unclassified' }
SPDebugErrorHandler >> unableToResumeResponse [
	| content |
	content := WAHtmlCanvas builder
		fullDocument: true;
		rootBlock: [ :root | root title: 'Unable to proceed' ];
		render: [ :html |
			html heading level1; with: 'Unable to proceed - hit the back button, and try again'.
			html paragraph: 'Some exceptions cannot be resumed. You will usually see this page if you hit Proceed while debugging one of these exceptions. Your request was aborted but you can retry it by refreshing the page.' ].
	self requestContext respond: [ :response |
		response
			internalError;
			contentType: self application contentType;
			nextPutAll: content ]
]
