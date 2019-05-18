Class {
	#name : #SPMonticelloPackageImageRepository,
	#superclass : #SPMonticelloPackageRepository,
	#instVars : [
		'packagesById'
	],
	#category : #'Spider-Model-MC-Repos'
}

{ #category : #queries }
SPMonticelloPackageImageRepository >> getMCPackageByMcId: aBytes ifAbsent: aBlock [

	^ packagesById at: aBytes ifAbsent: aBlock
]

{ #category : #queries }
SPMonticelloPackageImageRepository >> getMCPackageByName: aName andMcId: aBytes ifAbsent: aBlock [

	^ self getMCPackageByMcId: aBytes ifAbsent: aBlock 
]

{ #category : #initialization }
SPMonticelloPackageImageRepository >> initialize [

	super initialize.
	
	packagesById := Dictionary new
]

{ #category : #storing }
SPMonticelloPackageImageRepository >> storeMCPackage: aMCPackage [

	^ packagesById at: aMCPackage mcId ifAbsentPut: [ aMCPackage ]
]
