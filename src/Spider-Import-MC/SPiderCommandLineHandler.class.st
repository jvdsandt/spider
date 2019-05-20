Class {
	#name : #SPiderCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : #'Spider-Import-MC-Spider-Import-MC'
}

{ #category : #accessing }
SPiderCommandLineHandler class >> commandName [
	^ 'spider'
]

{ #category : #accessing }
SPiderCommandLineHandler class >> description [
	^ 'Import Smalltalk code from Monticello and Git repositories'
]

{ #category : #activation }
SPiderCommandLineHandler >> activate [
	self activateHelpWithoutArguments
		ifTrue: [ ^ self ].
	self subCommand = 'import'
		ifTrue: [ 
			self activateImport ]
]

{ #category : #activation }
SPiderCommandLineHandler >> activateImport [

	self inform: 'Spider: Import from ', self url asString
]

{ #category : #accessing }
SPiderCommandLineHandler >> availableSubCommands [
	^ #( 'import' )
]

{ #category : #accessing }
SPiderCommandLineHandler >> checkSubCommand: aString [ 
	(self availableSubCommands includes: aString)
		ifFalse: [
			self exitFailure: ('{1} subcommand does not exists' format: { aString }) ]
]

{ #category : #testing }
SPiderCommandLineHandler >> hasSQLiteDatabase [
	^ self hasOption: 'sqlitedb'
]

{ #category : #accessing }
SPiderCommandLineHandler >> sqlitedb [
	^ self optionAt: 'sqlitedb'
]

{ #category : #accessing }
SPiderCommandLineHandler >> subCommand [
	| firstArg |
	firstArg := self argumentAt: 1.
	self checkSubCommand: firstArg.
	^ firstArg
]

{ #category : #accessing }
SPiderCommandLineHandler >> url [
	^ self argumentAt: 2
]
