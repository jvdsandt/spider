Class {
	#name : #SPMethodNodeVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'builder'
	],
	#category : #'Spider-Model-Core-Builders'
}

{ #category : #'instance creation' }
SPMethodNodeVisitor class >> newWithBuilder: aBuilder [

	^ self new initWithBuilder: aBuilder
]

{ #category : #initialization }
SPMethodNodeVisitor >> initWithBuilder: aBuilder [

	builder := aBuilder
]

{ #category : #visiting }
SPMethodNodeVisitor >> visitMessageNode: aMessageNode [ 

	builder addSend: aMessageNode selector toSelf: aMessageNode isSelfSend toSuper: aMessageNode isSuperSend.
	super visitMessageNode: aMessageNode 
]

{ #category : #visiting }
SPMethodNodeVisitor >> visitMethodNode: aMethodNode [ 

	builder setImplements: aMethodNode selector.
	super visitMethodNode: aMethodNode 
]

{ #category : #visiting }
SPMethodNodeVisitor >> visitPragmaNode: aPragmaNode [

	builder 
		addPragma: aPragmaNode selector 
		arguments: (aPragmaNode arguments collect: [ :each | each value ]) asArray.
	super visitPragmaNode: aPragmaNode.
]

{ #category : #visiting }
SPMethodNodeVisitor >> visitVariableNode: aNode [

	aNode parent isMethod
		ifTrue: [ ^ self ].

	(aNode temporaryVariables includes: aNode name)
		ifTrue: [ ^self ].

	(aNode isSelf or: [ aNode isSuper or: [ aNode isArgument ] ])
		ifTrue: [ ^self ].
		
	builder addVariable: aNode name read: aNode isRead write: aNode isWrite
]
