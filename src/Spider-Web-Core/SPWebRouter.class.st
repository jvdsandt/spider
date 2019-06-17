Class {
	#name : #SPWebRouter,
	#superclass : #Object,
	#instVars : [
		'baseUrl'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #initialization }
SPWebRouter >> initialize [

	super initialize.
	
	baseUrl := WAUrl absolute: '/'
]

{ #category : #'as yet unclassified' }
SPWebRouter >> pathForClassEdition: aClass [

	^ Array with: 'class' with: aClass name with: aClass packageHash 
]

{ #category : #'as yet unclassified' }
SPWebRouter >> pathForGitCommit: aGitCommit [

	^ baseUrl copy 
		addToPath: 'git/commit';
		addToPath: aGitCommit shaString;
		yourself
]

{ #category : #'as yet unclassified' }
SPWebRouter >> pathForGitCommitBrowser: aGitCommit [

	^ baseUrl copy 
		addToPath: 'spider-browser';
		addField: 'commit' value: aGitCommit shaString;
		yourself
]

{ #category : #'as yet unclassified' }
SPWebRouter >> pathForGitRepo: aGitRepo [

	^ baseUrl copy 
		addToPath: 'git/repos';
		addToPath: aGitRepo domain asLowercase;
		addToPath: aGitRepo owner;
		addToPath: aGitRepo name;
		yourself
]

{ #category : #'as yet unclassified' }
SPWebRouter >> pathForPackageEdition: aPackage [

	^ Array with: 'package' with: aPackage name with: aPackage packageHash 
]

{ #category : #'as yet unclassified' }
SPWebRouter >> pathForPackageNamed: aName [

	^ Array with: 'package' with: aName
]
