Class {
	#name : #SPGitRepeCodeChecker,
	#superclass : #Object,
	#instVars : [
		'lgitRepo',
		'validShas',
		'invalidShas',
		'packages'
	],
	#category : #'Spider-Import-MC-Checks'
}

{ #category : #examples }
SPGitRepeCodeChecker class >> examplePharo [

	| localRef instance |
	
	localRef := '/Users/jan/Projects/SPImporter/github/pharo-project/pharo.git' asFileReference.
	instance := self new initWithLocalRef: localRef.
	
	instance checkRevparse: '3a40e7d'.
	^ instance
]

{ #category : #internal }
SPGitRepeCodeChecker >> addPackageNok: aName sha: sha commit: lgitCommit message: errorMsg [

	^ (packages at: aName ifAbsentPut: [ Dictionary new ])
		at: sha put: (
			(SPGitPackageCheck new initWithName: aName treeSha: sha)
				setErrorMessage: errorMsg;
				handleLGitCommit: lgitCommit;
				yourself)
]

{ #category : #internal }
SPGitRepeCodeChecker >> addPackageOk: aName sha: sha commit: lgitCommit snapshot: snapshot [.

	^ (packages at: aName ifAbsentPut: [ Dictionary new ])
		at: sha put: (
			(SPGitPackageCheck new initWithName: aName treeSha: sha)
				handleLGitCommit: lgitCommit;
				yourself)
]

{ #category : #actions }
SPGitRepeCodeChecker >> checkCommit: lgitCommit [

	| resolver codeReader lgitPackageNames allValid |

	resolver := SPGitFormatResolver onGitCommit: lgitCommit.
	resolver resolve.
	codeReader := resolver codeReader.
	
	lgitPackageNames := codeReader packageNames sorted.

	allValid := true.
	lgitPackageNames do: [ :each |
		(self checkPackage: each in: lgitCommit with: codeReader)
			ifFalse: [ allValid := false ] ].
	allValid
		ifTrue: [ validShas add: lgitCommit id hexString ]
		ifFalse: [ invalidShas add: lgitCommit id hexString ].

]

{ #category : #actions }
SPGitRepeCodeChecker >> checkCommitRecursively: lgitCommit [

	(self isAlreadyChecked: lgitCommit)
		ifTrue: [ ^ self ].
		
	self checkCommit: lgitCommit.
	
	lgitCommit parents do: [ :each |
		self checkCommitRecursively: each ]
]

{ #category : #internal }
SPGitRepeCodeChecker >> checkPackage: aName in: lgitCommit with: codeReader [

	| sha packageCheck |

	sha := codeReader getPackageSha: aName.
	packageCheck := self packageCheckFor: aName sha: sha ifAbsent: [ nil ].
	packageCheck notNil
		ifTrue: [ 
			packageCheck handleLGitCommit: lgitCommit.
			^ packageCheck isOk ].
	
	[ 
		| snapshot |
		snapshot := codeReader getPackageSnapshot: aName.
		self addPackageOk: aName sha: sha commit: lgitCommit snapshot: snapshot.
		self logInfo: aName, ': OK'.
		^ true
	] on: Error do: [ :ex |
		self addPackageNok: aName sha: sha commit: lgitCommit message: ex messageText.
		self logError: aName, ': ', ex messageText.
		ex return: nil ].
	^ false
]

{ #category : #actions }
SPGitRepeCodeChecker >> checkRevparse: aString [

	| lgitCommit |
	
	lgitCommit := self lgitRepo revparse: aString.
	(lgitCommit notNil and: [ lgitCommit isCommit ])
		ifTrue: [ self checkCommitRecursively: lgitCommit ]
]

{ #category : #initialization }
SPGitRepeCodeChecker >> initWithLocalRef: localRef [

	localRef exists
		ifFalse: [ self error: 'Local clone not found in ', localRef asString ].
		
	lgitRepo := LGitRepository on: localRef.
	lgitRepo open.
	
	validShas := Set new.
	invalidShas := Set new.
	packages := Dictionary new
]

{ #category : #initialization }
SPGitRepeCodeChecker >> initWithUrl: repoUrl [

	self initWithLocalRef: (SPGitImporter getLocalDirectoryFor: repoUrl).

]

{ #category : #testing }
SPGitRepeCodeChecker >> isAlreadyChecked: lgitCommit [
	| sha |
	sha := lgitCommit id hexString.
	^ (validShas includes: sha) or: [ invalidShas includes: sha ]
]

{ #category : #testing }
SPGitRepeCodeChecker >> isPackageAlreadyChecked: aName sha: aSha [

	^ (packages at: aName ifAbsent: [ ^ false ]) includesKey: aSha
]

{ #category : #accessing }
SPGitRepeCodeChecker >> lgitRepo [
	^ lgitRepo
]

{ #category : #accessing }
SPGitRepeCodeChecker >> packageCheckFor: aName sha: aSha ifAbsent: aBlock [

	^ (packages at: aName ifAbsent: [ ^ aBlock value ]) at: aSha ifAbsent: aBlock
]

{ #category : #accessing }
SPGitRepeCodeChecker >> packages [

	^ packages
]

{ #category : #accessing }
SPGitRepeCodeChecker >> packagesWithErrors [

	^ self packages 
			inject: OrderedCollection new
			into: [ :list :eachDict |
				list addAll: (eachDict reject: [ :each | each isOk ]).
				list ]
]
