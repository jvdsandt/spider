Class {
	#name : #SPDiffRecordBuilder,
	#superclass : #SPDiffVisitor,
	#instVars : [
		'records'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffAddedPackage: aDiff [

	self addPackageRecordOld: nil new: aDiff newObject
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffRemovedPackage: aDiff [

	aDiff oldObjects do: [ :each |
		self addPackageRecordOld: each new: nil ]
]

{ #category : #visiting }
SPDiffRecordBuilder >> visitDiffUpdatedPackage: aDiff [

	aDiff oldObjects do: [ :each |
		self addPackageRecordOld: each new: aDiff newObject ]
]
