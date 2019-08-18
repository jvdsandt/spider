Class {
	#name : #SPGitRepo,
	#superclass : #SPGlorpNode,
	#instVars : [
		'url',
		'commitRefs'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #utilities }
SPGitRepo class >> searchUrlFor: aDomain owner: anOwner name: aName [

	^ String streamContents: [ :s |
		s
			nextPutAll: 'https://';
			nextPutAll: aDomain;
			nextPutAll: '.com/';
			nextPutAll: anOwner;
			nextPut: $/;
			nextPutAll: aName;
			nextPutAll: '.git' ]
]

{ #category : #'instance creation' }
SPGitRepo class >> url: anUrl [

	^ self new initFromUrl: anUrl
]

{ #category : #comparing }
SPGitRepo >> = other [

	self == other ifTrue: [ ^ true ].
	self species = other species ifFalse: [ ^ false ].
	
	^ url = other url
]

{ #category : #accessing }
SPGitRepo >> branchNamed: aName [

	^ self branchNamed: aName ifAbsent: [ NotFound signalFor: aName ]
]

{ #category : #accessing }
SPGitRepo >> branchNamed: aName ifAbsent: aBlock [

	^ self commitRefs 
			detect: [ :each | each isBranch and: [ each name = aName ] ]
			ifNone: aBlock
]

{ #category : #accessing }
SPGitRepo >> commitRefs [
	^ commitRefs
]

{ #category : #accessing }
SPGitRepo >> domain [

	| hostName |
	
	hostName := self url asZnUrl host.
	hostName asLowercase = 'github.com'
		ifTrue: [ ^ 'GitHub' ].
	^ hostName
]

{ #category : #comparing }
SPGitRepo >> hash [

	^ url hash
]

{ #category : #accessing }
SPGitRepo >> homepageUrl [

	^ self url allButLast: 4
]

{ #category : #initialization }
SPGitRepo >> initFromUrl: anUrl [

	url := anUrl
]

{ #category : #accessing }
SPGitRepo >> lastDatetime [

	^ self mostRecentCommit ifNotNil: [ :c | c datetime ]
]

{ #category : #accessing }
SPGitRepo >> mostRecentBranches: maxCount [

	| sortedRefs |
	
	sortedRefs := (self commitRefs select: [ :each | each isBranch ]) sorted: [ :c1 :c2 | c1 datetime > c2 datetime ].
	^ sortedRefs size > maxCount 
			ifTrue: [ sortedRefs copyFrom: 1 to: maxCount ]
			ifFalse: [ sortedRefs ]
]

{ #category : #accessing }
SPGitRepo >> mostRecentCommit [

	| sortedRefs |
	
	sortedRefs := self commitRefs sorted: [ :c1 :c2 | c1 datetime <= c2 datetime ].
	^ sortedRefs isEmpty
		ifTrue: [ nil ]
		ifFalse: [ sortedRefs last commit ]
]

{ #category : #accessing }
SPGitRepo >> mostRecentTags: maxCount [

	| sortedRefs |
	
	sortedRefs := (self commitRefs select: [ :each | each isTag ]) sorted: [ :c1 :c2 | c1 datetime > c2 datetime ].
	^ sortedRefs size > maxCount 
			ifTrue: [ sortedRefs copyFrom: 1 to: maxCount ]
			ifFalse: [ sortedRefs ]
]

{ #category : #accessing }
SPGitRepo >> name [

	| projectName |

	projectName := self url asZnUrl pathSegments second.
	(projectName endsWith: '.git')
		ifTrue: [ projectName := projectName allButLast: 4 ].
	^ projectName
]

{ #category : #accessing }
SPGitRepo >> owner [

	^ self url asZnUrl pathSegments first
]

{ #category : #accessing }
SPGitRepo >> tagNamed: aName [

	^ self tagNamed: aName ifAbsent: [ NotFound signalFor: aName ]
]

{ #category : #accessing }
SPGitRepo >> tagNamed: aName ifAbsent: aBlock [

	^ self commitRefs 
			detect: [ :each | each isTag and: [ each name = aName ] ]
			ifNone: aBlock
]

{ #category : #accessing }
SPGitRepo >> url [

	^ url
]
