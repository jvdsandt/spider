Class {
	#name : #SPMonticelloPackageRDBRepositoryTest,
	#superclass : #SPiderTestCase,
	#category : #'Spider-Model-RDB-Tests'
}

{ #category : #accessing }
SPMonticelloPackageRDBRepositoryTest class >> resources [

	^ super resources, (Array with: SPiderContextTestResource)
]

{ #category : #asserting }
SPMonticelloPackageRDBRepositoryTest >> assertMCPackageV1: mcPackage [

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
SPMonticelloPackageRDBRepositoryTest >> assertMCPackageV2: mcPackage [

	self assert: mcPackage mcId equals: (ByteArray withAll: (UUID fromString: 'f87e159a-ec43-4835-884f-d75a2b08454f')).
	self assert: mcPackage name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: mcPackage author equals: 'JanVanDeSandt'.
	self assert: mcPackage version equals: 2.
	self assert: mcPackage message equals: 'Added a second class'.
	self assert: mcPackage datetime equals: (DateAndTime fromString: '2013-02-16T21:18:42.835+00:00').
	
	self assert: mcPackage ancestors size equals: 1.
	self assertMCPackageV1: mcPackage ancestors first.
	
	mcPackage package
		ifNotNil: [ :p | self assertPackageV2: p ]

]

{ #category : #asserting }
SPMonticelloPackageRDBRepositoryTest >> assertPackageV1: package [

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

{ #category : #asserting }
SPMonticelloPackageRDBRepositoryTest >> assertPackageV2: package [

	| spiderClass |

	self assert: package name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: package classNames equals: #( CFDemoClassA CFDemoClassB ).
	
	spiderClass := package classNamed: #CFDemoClassA.
	self assert: spiderClass comment equals: 'A CFDemoClassA class is just a stupid class to test the MC import functionality of SmalltalkGraph.'.
	self assert: spiderClass instanceVarNames equals: #( demoInstVar ).
	self assert: spiderClass classVarNames equals: #( demoClassVar ).
	self assert: spiderClass classInstanceVarNames equals: #( demoClassInstVar ).
	self assert: spiderClass instanceSelectors equals: #( demoMethod ).
	self assert: spiderClass classSelectors equals: #( demoClassMethod ).
	
	spiderClass := package classNamed: #CFDemoClassB.
	self assert: spiderClass superclassName equals: #Object.
]

{ #category : #asserting }
SPMonticelloPackageRDBRepositoryTest >> assertPackageV3: package [

	| spiderClass |

	self assert: package name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: package classNames equals: #( CFDemoClassA CFDemoClassB ).
	
	spiderClass := package classNamed: #CFDemoClassB.
	self assert: spiderClass superclassName equals: #Magnitude.
]

{ #category : #asserting }
SPMonticelloPackageRDBRepositoryTest >> assertPackageV4: package [

	| spiderClass ext |

	self assert: package name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: package classNames equals: #( CFDemoClassA CFDemoClassB ).
	self assert: package classExtensionNames equals: #( Fraction Integer Magnitude ).
	
	spiderClass := package classNamed: #CFDemoClassB.
	self assert: spiderClass superclassName equals: #Magnitude.
	
	ext := package classExtensionNamed: #Fraction.
	self assert: ext instanceSelectors equals: #( demoInstanceExtension ).
	self assert: ext classSelectors equals: #( demoClassExtension ).
	
	ext := package classExtensionNamed: #Integer.
	self assert: ext instanceSelectors equals: #( ).
	self assert: ext classSelectors equals: #( demoClassExtension ).

	ext := package classExtensionNamed: #Magnitude.
	self assert: ext instanceSelectors equals: #( demoInstanceExtension ).
	self assert: ext classSelectors equals: #( ).

]

{ #category : #asserting }
SPMonticelloPackageRDBRepositoryTest >> assertPackageV5: package [

	| spiderClass ext |

	self assert: package name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: package classNames equals: #( CFDemoClassA CFDemoClassB ).
	self assert: package classExtensionNames equals: #( Fraction Integer Magnitude ).
	
	spiderClass := package classNamed: #CFDemoClassA.
	self assert: spiderClass poolDictionaryNames equals: #( ChronologyConstants )
]

{ #category : #asserting }
SPMonticelloPackageRDBRepositoryTest >> assertPackageV6: package [

	| spiderTrait classA |

	self assert: package name equals: 'SmalltalkGraph-Tests-Package'.
	self assert: package classNames equals: #( CFDemoClassA CFDemoClassB CFDemoTrait ).
	self assert: package classExtensionNames equals: #( Fraction Integer Magnitude ).
	
	spiderTrait := package classNamed: #CFDemoTrait.
	self assert: spiderTrait isSpiderTrait.
	self assert: spiderTrait instanceSelectors equals: #( demoTraitMethodA demoTraitMethodB ).
	self assert: spiderTrait classSelectors equals: #( ).
	
	classA := package classNamed: #CFDemoClassA.
	self deny: classA isSpiderTrait.
	self assert: classA traitCompositionString equals: 'CFDemoTrait'.
	self assert: classA classTraitCompositionString equals: 'CFDemoTrait classTrait'.
]

{ #category : #running }
SPMonticelloPackageRDBRepositoryTest >> createContext [

	^ SPiderContextTestResource current context
]

{ #category : #accessing }
SPMonticelloPackageRDBRepositoryTest >> getTestPackages [

	^ SPMonticelloTestPackages new
]

{ #category : #running }
SPMonticelloPackageRDBRepositoryTest >> setUp [

	super setUp.
	SPiderContextTestResource current resetForMCPackages
]

{ #category : #running }
SPMonticelloPackageRDBRepositoryTest >> tearDown [

	context := nil.
	super tearDown
]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV1 [

	| repo mcVersion mcPackage |

	repo := self mcPackageRepo.
	mcVersion := self getTestPackages testPackageV1.
	
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.
	self assertMCPackageV1: mcPackage
]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV1andV2 [

	| repo mcP1 mcP2 |

	repo := self mcPackageRepo.
	
	mcP1 := repo newBuilder buildFromMCVersion: self getTestPackages testPackageV1.
	self assertMCPackageV1: mcP1.
	
	mcP2 := repo newBuilder buildFromMCVersion: self getTestPackages testPackageV2.
	self assertMCPackageV2: mcP2.
	self assertMCPackageV1: mcP1.

]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV1andV2WithRepo [

	| repo mcRepoUrl mcP1 mcP2 |

	repo := self mcPackageRepo.
	mcRepoUrl := 'https://myrepo.com/project'.
	
	mcP1 := repo newBuilder buildFromMCVersion: self getTestPackages testPackageV1.
	repo storeRepoUrl: mcRepoUrl filename: 'v1.mcz' package: mcP1. 
	self assertMCPackageV1: mcP1.
	
	mcP2 := repo newBuilder buildFromMCVersion: self getTestPackages testPackageV2.
	repo storeRepoUrl: mcRepoUrl filename: 'v2.mcz' package: mcP2. 
	self assertMCPackageV2: mcP2.
	
	self assert: (repo getMCPackageForRepo: mcRepoUrl andFile: 'v1.mcz' ifAbsent: [ nil ]) notNil.
	self assert: (repo getMCPackageForRepo: mcRepoUrl andFile: 'v2.mcz' ifAbsent: [ nil ]) notNil.
	self assert: (repo getMCPackageForRepo: mcRepoUrl andFile: 'v3.mcz' ifAbsent: [ nil ]) isNil.

]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV2 [

	| repo mcVersion mcPackage ancestor |

	repo := self mcPackageRepo.
	mcVersion := self getTestPackages testPackageV2.
	
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.
	self assertMCPackageV2: mcPackage.

	ancestor := mcPackage ancestors first.
	self assertMCPackageV1: ancestor.


]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV2andV1 [

	| repo mcP1 mcP2 |

	repo := self mcPackageRepo.
	
	mcP2 := repo newBuilder buildFromMCVersion: self getTestPackages testPackageV2.

	self assertMCPackageV2: mcP2.
	self assertPackageV2: mcP2 package.
	self assert: mcP2 ancestors first package isNil.

	mcP1 := repo newBuilder buildFromMCVersion: self getTestPackages testPackageV1.

	self assertMCPackageV1: mcP1.
	self assertPackageV1: mcP1 package.
	
	self assertMCPackageV2: mcP2.
	self assertPackageV2: mcP2 package.

]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV3 [

	| repo mcVersion mcPackage |

	repo := self mcPackageRepo.
	mcVersion := self getTestPackages testPackageV3.
	
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.
	self assertPackageV3: mcPackage package.
]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV4 [

	| repo mcVersion mcPackage |

	repo := self mcPackageRepo.
	mcVersion := self getTestPackages testPackageV4.
	
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.
	self assertPackageV4: mcPackage package.
]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV5 [

	| repo mcVersion mcPackage |

	repo := self mcPackageRepo.
	mcVersion := self getTestPackages testPackageV5.
	
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.
	self assertPackageV5: mcPackage package.
]

{ #category : #tests }
SPMonticelloPackageRDBRepositoryTest >> testPackageV6 [

	| repo mcVersion mcPackage |

	repo := self mcPackageRepo.
	mcVersion := self getTestPackages testPackageV6.
	
	mcPackage := repo newBuilder buildFromMCVersion: mcVersion.
	self assertPackageV6: mcPackage package.
]
