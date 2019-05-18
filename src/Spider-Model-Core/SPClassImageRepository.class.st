Class {
	#name : #SPClassImageRepository,
	#superclass : #SPClassRepository,
	#instVars : [
		'classesByHash'
	],
	#category : #'Spider-Model-Core-Repos'
}

{ #category : #queries }
SPClassImageRepository >> getClassByHash: aBytes ifAbsent: aBlock [

	^ classesByHash at: aBytes ifAbsent: aBlock
]

{ #category : #initialization }
SPClassImageRepository >> initialize [

	super initialize.
	classesByHash := Dictionary new
]

{ #category : #stroring }
SPClassImageRepository >> storeClass: aSpiderClass [

	^ classesByHash at: aSpiderClass classHash ifAbsentPut: [ aSpiderClass ]
]

{ #category : #stroring }
SPClassImageRepository >> storeClassExtension: aClassExtension [

	^ classesByHash at: aClassExtension classHash ifAbsentPut: [ aClassExtension ]
]
