"
Usage: import [--help] [ --databaseUrl=<dburl> ] [ --gitRepos=<path> ] <URL>
	--help         list this help message
	--databaseUrl  the database address
	--gitRepos     a local repository to store the Git repository clones
	<URL>          the url of teh Git or Monticello repository

Documentation:
The spider command line handler runs the spider git or MC importer.

"
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
	self initSPLogger.
	self activateHelpWithoutArguments
		ifTrue: [ ^ self ].
	self subCommand = 'import'
		ifTrue: [ ^ self activateImport ].
	self subCommand = 'setGitCommitRootIds'
		ifTrue: [ ^ self activateSetGitCommitRootIds ]
]

{ #category : #activation }
SPiderCommandLineHandler >> activateImport [

	self url isEmptyOrNil 
		ifTrue: [ ^ self exitFailure: 'url argument missing' ].
	self logInfo: 'Import from ', self url asString.
	
	self databaseUrl isEmptyOrNil 
		ifTrue: [ ^ self exitFailure: 'databaseUrl option missing' ].
	SPImporter databaseUrl: self databaseUrl.
	
	self doGitImport.
	
	self logInfo: 'Import finished.'.
	self quit
]

{ #category : #activation }
SPiderCommandLineHandler >> activateSetGitCommitRootIds [

	self url isEmptyOrNil 
		ifTrue: [ ^ self exitFailure: 'url argument missing' ].
	self logInfo: 'SetGitCommitRootIds'.
	
	self databaseUrl isEmptyOrNil 
		ifTrue: [ ^ self exitFailure: 'databaseUrl option missing' ].
	SPImporter databaseUrl: self databaseUrl.
	SPWebContext databaseUrl: self databaseUrl.
	
	self doSetGitCommitRootIds.
	
	self logInfo: 'SetGitCommitRootIds finished.'.
	self quit
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

{ #category : #accessing }
SPiderCommandLineHandler >> databaseUrl [
	^ (self hasOption: 'databaseUrl')
			ifTrue: [ self optionAt: 'databaseUrl' ]
			ifFalse: [ OSEnvironment current at: 'SPIDER_DBURL' ifAbsent: [ nil ] ]
]

{ #category : #activation }
SPiderCommandLineHandler >> doGitImport [

	self gitRepos isEmptyOrNil 
		ifTrue: [ ^ self exitFailure: 'gitRepo option missing' ].
	self logInfo: 'Local git repo location: ', self gitRepos.
	SPGitImporter reposLocation: self gitRepos.
	
	SPGitImporter import: self url.
	
	self quit.
]

{ #category : #activation }
SPiderCommandLineHandler >> doSetGitCommitRootIds [

	SPWebContext default do: [ SPSetGitCommitRootIds new execute ]
]

{ #category : #accessing }
SPiderCommandLineHandler >> gitRepos [
	^ (self hasOption: 'gitRepos')
			ifTrue: [ self optionAt: 'gitRepos' ]
			ifFalse: [ OSEnvironment current at: 'SPIDER_GIT_REPOS' ifAbsent: [ nil ] ]
]

{ #category : #activation }
SPiderCommandLineHandler >> initSPLogger [

	SPLogger default: SPTranscriptLogger new
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
	self arguments size < 2
		ifTrue: [ ^ self exitFailure: 'url argument missing' ].
	^ self argumentAt: 2
]
