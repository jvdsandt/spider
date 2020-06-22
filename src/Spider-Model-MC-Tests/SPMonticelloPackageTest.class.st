Class {
	#name : #SPMonticelloPackageTest,
	#superclass : #TestCase,
	#category : #'Spider-Model-MC-Tests'
}

{ #category : #asserting }
SPMonticelloPackageTest >> assertMCPackageV1: mcPackage [

	self assert: mcPackage mcId equals: (ByteArray withAll: (UUID fromString: 'bb9e37bf-b7a0-4892-a522-eee4416ec8d5')).
	self assert: mcPackage name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: mcPackage author equals: 'JanVanDeSandt'.
	self assert: mcPackage version equals: 1.
	self assert: mcPackage message equals: 'initial version with a single class.'.
	self assert: mcPackage datetime equals: (DateAndTime fromString: '2013-02-16T21:16:35.354+00:00').
	
	self assert: mcPackage ancestors isEmpty.
	
	mcPackage package
		ifNotNil: [ :p | self assertPackageV1: p ]
]

{ #category : #asserting }
SPMonticelloPackageTest >> assertMCPackageV2: mcPackage [

	self assert: mcPackage mcId equals: (ByteArray withAll: (UUID fromString: 'f87e159a-ec43-4835-884f-d75a2b08454f')).
	self assert: mcPackage name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: mcPackage author equals: 'JanVanDeSandt'.
	self assert: mcPackage version equals: 2.
	self assert: mcPackage message equals: 'Added a second class'.
	self assert: mcPackage datetime equals: (DateAndTime fromString: '2013-02-16T21:18:42.835Z').
	
	self assert: mcPackage ancestors size equals: 1.

]

{ #category : #asserting }
SPMonticelloPackageTest >> assertPackageV1: package [

	| spiderClass |

	self assert: package name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: package classNames equals: #( CFDemoClassA ).
	
	spiderClass := package classNamed: #CFDemoClassA.
	self assert: spiderClass comment equals: 'A CFDemoClassA class is just a stupid class to test the MC import functionality of SmalltalkGraph.'.
	self assert: spiderClass instanceVarNames equals: #( demoInstVar ).
	self assert: spiderClass classVarNames equals: #( demoClassVar ).
	self assert: spiderClass classInstanceVarNames equals: #( demoClassInstVar ).
	self assert: spiderClass instanceSelectors equals: #( demoMethod ).
	self assert: spiderClass classSelectors equals: #( demoClassMethod ).
]

{ #category : #accessing }
SPMonticelloPackageTest >> getTestPackages [

	^ SPMonticelloTestPackages new
]

{ #category : #accessing }
SPMonticelloPackageTest >> testPackageV1 [

	| repo mcVersion mcPackage |

	repo := SPiderImageContext new mcPackageRepo.

	mcVersion := self getTestPackages testPackageV1.
	
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.
	self assertMCPackageV1: mcPackage.

]

{ #category : #accessing }
SPMonticelloPackageTest >> testPackageV2 [

	| repo mcVersion2 mcPackage2 |

	repo := SPiderImageContext new mcPackageRepo.

	repo newBuilder buildFromMCVersion: self getTestPackages testPackageV1.

	mcVersion2 := self getTestPackages testPackageV2.
	mcPackage2 := repo newBuilder buildFromMCVersion: mcVersion2.
	self assertMCPackageV2: mcPackage2.

]

{ #category : #accessing }
SPMonticelloPackageTest >> testPackageV3 [

	| repo mcVersion mcPackage |

	repo := SPiderImageContext new mcPackageRepo.

	repo newBuilder buildFromMCVersion: self getTestPackages testPackageV1.
	repo newBuilder buildFromMCVersion: self getTestPackages testPackageV2.

	mcVersion := self getTestPackages testPackageV3.
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.

]

{ #category : #accessing }
SPMonticelloPackageTest >> testPackageV3Diff [

	| repo mcVersion mcPackage diffs |

	repo := SPiderImageContext new mcPackageRepo.

	repo newBuilder buildFromMCVersion: self getTestPackages testPackageV1.
	repo newBuilder buildFromMCVersion: self getTestPackages testPackageV2.

	mcVersion := self getTestPackages testPackageV3.
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.
	diffs := mcPackage diffs.
	
	self assert: diffs size equals: 2.

]
