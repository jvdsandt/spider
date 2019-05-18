Class {
	#name : #SPPackageImageRepository,
	#superclass : #SPPackageRepository,
	#instVars : [
		'packagesByHash'
	],
	#category : #'Spider-Model-Core-Repos'
}

{ #category : #queries }
SPPackageImageRepository >> getPackageByHash: aBytes ifAbsent: aBlock [

	^ packagesByHash at: aBytes ifAbsent: aBlock
]

{ #category : #queries }
SPPackageImageRepository >> getPackageById: anId [

	^ self getPackageByHash: anId ifAbsent: [ NotFound signalFor: anId ]
]

{ #category : #initialization }
SPPackageImageRepository >> initialize [

	super initialize.
	
	packagesByHash := Dictionary new.
]

{ #category : #storing }
SPPackageImageRepository >> storePackage: aPackage [

	packagesByHash at: aPackage packageHash ifAbsentPut: [ aPackage ].
	^ aPackage packageHash
]
