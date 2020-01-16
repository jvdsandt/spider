Class {
	#name : #SPLatestImportsView,
	#superclass : #SPComponent,
	#instVars : [
		'count'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPLatestImportsView >> count [

	^ count ifNil: [ count := 25 ]
]

{ #category : #accessing }
SPLatestImportsView >> count: anInteger [

	count := anInteger
]

{ #category : #rendering }
SPLatestImportsView >> renderCommit: aCommit on: html [

	html paragraph: [ 
		html text: 'Commit: '; text: aCommit shaString; break.
		html text: 'Author: '; text: aCommit authorName; break.
		html text: 'Date: '. 
		self renderDateTime: aCommit datetime on: html.
		html break.
		html text: aCommit message 
		
		 ]


]

{ #category : #rendering }
SPLatestImportsView >> renderContentOn: html [ 

	| transactions commits packages |
	
	transactions := self selectLatestTransactions.

	commits := self gitRepo getCommitsCreatedAfter: transactions last startedAt.
	commits := commits groupedBy: #transaction.
	
	packages := self context packageRepo getPackagesCreatedAfter: transactions last startedAt.
	packages := packages groupedBy: #transaction.
	
	transactions do: [ :each |
		self renderImport: each 
				commits: (commits at: each ifAbsent: [ #() ])
				packages: (packages at: each ifAbsent: [ #() ]) 
				on: html ].

]

{ #category : #rendering }
SPLatestImportsView >> renderImport: aTransaction commits: commitList packages: packageList on: html [

	(commitList isEmpty and: [ packageList isEmpty ])
		ifTrue: [ ^ self ].
		
	html heading
		level: 3;
		with: [ 
			html text: 'Imported at '.
			self renderDateTime: aTransaction startedAt on: html ].
		
	commitList do: [ :each |
		self renderCommit: each on: html ].
	
	packageList notEmpty
		ifTrue: [ 
			html paragraph: 'New packages:'.
			html unorderedList: [ 
				packageList sorted do: [ :each |
					self renderPackage: each on: html ] ] ].
]

{ #category : #rendering }
SPLatestImportsView >> renderPackage: aPackage on: html [

	html listItem: [ 
		html text: aPackage name.
		html space.
		html text: aPackage packageHashLabel ]
]

{ #category : #rendering }
SPLatestImportsView >> selectLatestTransactions [

	^ self context sessionRepo latestTransactions: self count
]
