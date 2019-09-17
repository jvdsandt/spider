Class {
	#name : #SPMonticelloPackageBuilder,
	#superclass : #Object,
	#instVars : [
		'repo',
		'name',
		'mcId',
		'version',
		'author',
		'datetime',
		'message',
		'package',
		'ancestors',
		'branch'
	],
	#category : #'Spider-Model-MC-Builders'
}

{ #category : #utilities }
SPMonticelloPackageBuilder class >> cleanUpString: aString [

	| str |
	
	aString notNil
		ifTrue: [ 
			str := aString withUnixLineEndings trimBoth reject: [ :ch | ch asInteger = 0 ].
			str isEmpty
				ifTrue: [ str := nil ] ].
	^ str
]

{ #category : #internal }
SPMonticelloPackageBuilder >> addSnapshot: aSnapshot to: aMCPackage [

	name := aMCPackage name.
	self privateImportMCClasses: aSnapshot.
	
	^repo updateMCPackage: aMCPackage package: package
]

{ #category : #building }
SPMonticelloPackageBuilder >> buildFromMCVersion: aMCVersion [

	| mcPackage mcPackageName |
	
	mcId := ByteArray newFrom: aMCVersion info id.

	mcPackageName := self getPackageName: aMCVersion info.
	mcPackage := repo getMCPackageByName: mcPackageName andMcId: mcId ifAbsent: [ nil ].
	mcPackage notNil
		ifTrue: [
			mcPackage package isNil
				ifTrue: [ mcPackage := self addSnapshot: aMCVersion snapshot to: mcPackage ].
			^ mcPackage ].

	self privateImportMCVersionInfo: aMCVersion info.
	self privateImportMCClasses: aMCVersion snapshot.
	
	mcPackage := self createMCPackage.
	repo storeMCPackage: mcPackage.
	^ mcPackage
]

{ #category : #building }
SPMonticelloPackageBuilder >> buildFromMCVersionInfo: aMCVersionInfo [

	| mcPackage mcPackageName |
	
	mcId := ByteArray newFrom: aMCVersionInfo id.

	mcPackageName := self getPackageName: aMCVersionInfo.
	mcPackage := repo getMCPackageByName: mcPackageName andMcId: mcId ifAbsent: [ nil ].
	mcPackage notNil
		ifTrue: [ ^ mcPackage ].

	self privateImportMCVersionInfo: aMCVersionInfo.

	mcPackage := self createMCPackage.
	repo storeMCPackage: mcPackage.
	^ mcPackage
]

{ #category : #internal }
SPMonticelloPackageBuilder >> createMCPackage [
	
	^ SPMonticelloPackage name: name
		mcId: mcId 
		version: version
		branch: branch
		author: author
		datetime: datetime 
		message: message
		package: package 
		ancestors: ancestors
	
	

	
]

{ #category : #internal }
SPMonticelloPackageBuilder >> getPackageName: aVersionInfo [
	
	| basicName |

	basicName := aVersionInfo name last isDigit
		ifTrue: [ aVersionInfo name ]
		ifFalse: [ (aVersionInfo name copyUpToLast: $.) copyUpTo: $( ].

	name := basicName copyUpToLast: $-.
	(name includes: $.)
		ifTrue: [ name := name copyUpTo: $. ].
		
	^ name
]

{ #category : #initialization }
SPMonticelloPackageBuilder >> initialize [

	super initialize.
	self reset
]

{ #category : #internal }
SPMonticelloPackageBuilder >> packageRepo [

	^ repo packageRepo
]

{ #category : #internal }
SPMonticelloPackageBuilder >> parseMCName: aString [
	"Copied from GoferVersionReference >> #parseName"
	
	| basicName |

	basicName := aString last isDigit
		ifTrue: [ aString ]
		ifFalse: [ (aString copyUpToLast: $.) copyUpTo: $( ].

	name := basicName copyUpToLast: $-.
	(name includes: $.)
		ifFalse: [ branch := nil ]
		ifTrue: [
			branch := name copyAfter: $..
			name := name copyUpTo: $. ].

	author := (basicName copyAfterLast: $-) copyUpToLast: $..

	version := (basicName copyAfterLast: $-) copyAfterLast: $..
	version := (version notEmpty and: [ version allSatisfy: [ :each | each isDigit ] ])
		ifTrue: [ version asInteger ]
		ifFalse: [ 0 ]
]

{ #category : #internal }
SPMonticelloPackageBuilder >> privateImportMCAncestors: aMCVersionInfo [
	"Recursively create Package nodes for the ancestors of <aVersionInfo> if these
	nodes are not present yet. "

	aMCVersionInfo ancestors do: [ :each |
		| ancestor |
		ancestor := repo newBuilder buildFromMCVersionInfo: each.
		ancestors add: ancestor ]
]

{ #category : #internal }
SPMonticelloPackageBuilder >> privateImportMCClasses: aSnapshot [

	| packageBuilder |
	
	packageBuilder := self packageRepo newMCBuilder.
	packageBuilder name: name.
	packageBuilder snapshot: aSnapshot.
	
	package := packageBuilder build
]

{ #category : #internal }
SPMonticelloPackageBuilder >> privateImportMCVersionInfo: aMCVersionInfo [

	self parseMCName: aMCVersionInfo name.

	message := self class cleanUpString: aMCVersionInfo message.
	datetime := (DateAndTime date: aMCVersionInfo date time: (aMCVersionInfo time ifNil: [ Time midnight ])) translateToUTC.
	
	self privateImportMCAncestors: aMCVersionInfo
]

{ #category : #initialization }
SPMonticelloPackageBuilder >> reset [ 

	name := nil.
	mcId := nil.
	version := nil.
	author := nil.
	datetime := nil.
	message := nil.
	package := nil.
	ancestors := Set new
]

{ #category : #initialization }
SPMonticelloPackageBuilder >> setRepo: aMCPackageRepo [

	repo := aMCPackageRepo
]
