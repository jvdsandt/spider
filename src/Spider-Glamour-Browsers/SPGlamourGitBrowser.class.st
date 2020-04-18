Class {
	#name : #SPGlamourGitBrowser,
	#superclass : #SPGlamourBrowser,
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #creating }
SPGlamourGitBrowser >> createClassDiffsTable: composite [ 

	^ composite fastTable
			title: 'Class diffs';
			column: 'Name' evaluated: [ :each | each name ] width: 160;
			column: 'Type' evaluated: [ :each | each classType ] width: 80;
			column: 'Old' evaluated: [ :each | each oldHashLabel ] width: 100;
			column: 'New' evaluated: [ :each | each newHashLabel ] width: 100;
			yourself
]

{ #category : #creating }
SPGlamourGitBrowser >> createCommitsTable: composite [ 

	^ composite fastTable
			title: 'Commits';
			column: 'Timestamp' evaluated: [ :each | each datetime ] width: 160;
			column: 'Commit' evaluated: [ :each | each shaShortString ] width: 80;
			column: 'Author' evaluated: [ :each | each authorName ] width: 160;
			column: 'Message' evaluated: [ :each | each messageLine ];
			selectionAct: [ :table :a :b :c | { table. a. b. c. } inspect ] entitled: 'Browse';
			selectionAct: [ :table | ] entitled: 'Check';
			selectionAct: [ :table | self openCommitOnWeb: table rawSelection ] entitled: 'Open on web';
			selectionAct: [ :table | SPGitDiffBrowser new openOn: table rawSelection ] entitled: 'Diffs';
			selectionAct: [ :table | table rawSelection inspect ] entitled: 'Inspect it';
			yourself
]

{ #category : #creating }
SPGlamourGitBrowser >> createMethodDiffsTable: composite [ 

	^ composite fastTable
			title: 'Method diffs';
			column: 'Class' evaluated: [ :each | each className ] width: 160;
			column: 'Meta' evaluated: [ :each | each isMeta ] width: 80;
			column: 'Selector' evaluated: [ :each | each selector ] width: 200;
			column: 'Old' evaluated: [ :each | each oldHashLabel ] width: 100;
			column: 'New' evaluated: [ :each | each newHashLabel ] width: 100;
			yourself
]

{ #category : #creating }
SPGlamourGitBrowser >> createPackageDiffsTable: composite [ 

	^ composite fastTable
			title: 'Package diffs';
			column: 'Name' evaluated: [ :each | each name ] width: 160;
			column: 'Old' evaluated: [ :each | each oldHashLabel ] width: 100;
			column: 'New' evaluated: [ :each | each newHashLabel ] width: 100;
			yourself
]

{ #category : #queries }
SPGlamourGitBrowser >> getClassDiffsOfCommit: aGitCommit [

	| list |
	
	list := self diffRepo getClassDiffsOfCommit: aGitCommit.
	^ list sorted: [ :a :b | a name <= b name ]
]

{ #category : #queries }
SPGlamourGitBrowser >> getMethodDiffsOfCommit: aGitCommit [

	| list |
	
	list := self diffRepo getMethodDiffsOfCommit: aGitCommit.
	^ list sorted: [ :a :b | 
		a className = b className
			ifTrue: [ a selector <= b selector ]
			ifFalse: [ a className <= b className ] ]
]

{ #category : #queries }
SPGlamourGitBrowser >> getPackageDiffsOfCommit: aGitCommit [

	| list |
	
	list := self diffRepo getPackageDiffsOfCommit: aGitCommit.
	^ list sorted: [ :a :b | a name <= b name ]
]

{ #category : #actions }
SPGlamourGitBrowser >> openCommitOnWeb: aGitCommit [

	| repos |
	
	repos := self gitRepo getReposWithCommitSha: aGitCommit shaString.
	repos isEmpty
		ifTrue: [ ^ self ].

	self openRepoOnWeb: repos first commit: aGitCommit
]

{ #category : #actions }
SPGlamourGitBrowser >> openRepoOnWeb: aGitRepo [

	WebBrowser openOn: aGitRepo htmlUrl
]

{ #category : #actions }
SPGlamourGitBrowser >> openRepoOnWeb: aGitRepo commit: aGitCommit [

	WebBrowser openOn: (aGitRepo htmlUrlForSha: aGitCommit shaString)
]
