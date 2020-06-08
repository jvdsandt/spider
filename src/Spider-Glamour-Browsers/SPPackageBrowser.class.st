Class {
	#name : #SPPackageBrowser,
	#superclass : #SPGlamourBrowser,
	#instVars : [
		'packagesCriteria',
		'packagesLimit'
	],
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #private }
SPPackageBrowser >> createBrowser [

	^ GLMCompositePresentation new tabulator 
			with: [ :t |
				t title: 'Spider Package Browser'.
				t row: [ :r |
					r column: #packages span: 1.
					r column: #editions span: 2 ].
				t row: [ :r |
					r column: #description ].
				t transmit to: #packages; andShow: [ :composite | 
					composite list
						format: [ :p | p ] ].
				t transmit from: #packages; to: #editions; andShow: [ :composite |
					(self createMCPackagesTable: composite)
						display: [ :name | self mcPackageRepo getMCPackagesWithPackageNamed: name ] ].
				t transmit from: #editions; to: #description; andShow: [ :composite |
					composite text
						display: [ :mcPackage | mcPackage summary ]
					 ] ]
]

{ #category : #'as yet unclassified' }
SPPackageBrowser >> createMCPackagesTable: composite [ 

	^ composite fastTable
			title: 'MC Packages';
			column: 'Timestamp' evaluated: [ :each | each datetime ] width: 160;
			column: 'Version' evaluated: [ :each | each version ] width: 50;
			column: 'Author' evaluated: [ :each | each author ] width: 90;
			column: 'Message' evaluated: [ :each | each messageLine ];
			selectionAct: [ :table :a :b :c | { table. a. b. c. } inspect ] entitled: 'Browse';
			selectionAct: [ :table | ] entitled: 'Check';
			selectionAct: [ :table | SPGitDiffBrowser new openOn: table rawSelection ] entitled: 'Diffs';
			selectionAct: [ :table | table rawSelection inspect ] entitled: 'Inspect it';
			yourself
]

{ #category : #initialization }
SPPackageBrowser >> initialize [

	packagesLimit := 10000.
	packagesCriteria := SPStringSearchCriteria new
		term: '';
		caseSensitive: false;
		wildcardAfter: true;
		yourself
]

{ #category : #private }
SPPackageBrowser >> open [

	| list |
	
	list := self context packageRepo getPackageNames: self packagesCriteria max: self packagesLimit. 
	self createBrowser openOn: list
]

{ #category : #accessing }
SPPackageBrowser >> packagesCriteria [
	^ packagesCriteria
]

{ #category : #accessing }
SPPackageBrowser >> packagesCriteria: anObject [
	packagesCriteria := anObject
]

{ #category : #accessing }
SPPackageBrowser >> packagesLimit [
	^ packagesLimit
]

{ #category : #accessing }
SPPackageBrowser >> packagesLimit: anInteger [
	packagesLimit := anInteger
]
