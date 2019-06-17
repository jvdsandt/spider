Class {
	#name : #SPComponent,
	#superclass : #WAComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPComponent >> context [

	^ self webContext context
]

{ #category : #accessing }
SPComponent >> mcPackageRepo [ 

	^ self context mcPackageRepo
]

{ #category : #actions }
SPComponent >> openBrowserOnPackage: aPackage [

	self show: (SPBrowserComponent onPackage: aPackage)
]

{ #category : #actions }
SPComponent >> openBrowserOnPackages: aPackages [

	self show: (SPBrowserComponent onPackages: aPackages)
]

{ #category : #actions }
SPComponent >> openGitCommit: aGitCommit [

	self show: (SPGitCommitDetailsView new
		gitCommit: aGitCommit;
		yourself)
]

{ #category : #actions }
SPComponent >> openMCAuthor: anAuthor [

	self show: (SPMCAuthorView new
		author: anAuthor;
		yourself)
]

{ #category : #actions }
SPComponent >> openMCPackage: aMCPackage [

	self show: (SPMCPackageDetailsView new
		mcPackage: aMCPackage;
		yourself)
]

{ #category : #actions }
SPComponent >> openMCRepo: aMCRepo [

	self show: (SPMCRepoDetailsView new
		mcRepo: aMCRepo;
		yourself)
]

{ #category : #actions }
SPComponent >> openPackage: aPackage [

	self show: (SPPackageDetailsView new
		package: aPackage;
		yourself)
]

{ #category : #accessing }
SPComponent >> queries [

	^ self webContext queries
]

{ #category : #rendering }
SPComponent >> renderDateTime: dt on: html [

	html text: (String streamContents: [ :s |
		BasicDatePrinter default printYMD: dt withLeadingSpace: true on: s.
		s nextPut: Character space.
		BasicDatePrinter default printHMS: dt separatedBy: $: on: s ])
]

{ #category : #'as yet unclassified' }
SPComponent >> router [

	^ SPWebRouter new
]

{ #category : #accessing }
SPComponent >> webContext [

	^ SPWebContext default
]
