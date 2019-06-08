Class {
	#name : #SPDiffVisitor,
	#superclass : #Object,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPDiffVisitor >> visitDiff: anObject [


]

{ #category : #visiting }
SPDiffVisitor >> visitDiffAdd: anObject [

	self visitDiff: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffAddedClass: anObject [

	self visitDiffAdd: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffAddedMethod: anObject [

	self visitDiffAdd: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffAddedPackage: anObject [

	self visitDiffAdd: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffRemove: anObject [

	self visitDiff: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffRemovedClass: anObject [

	self visitDiffRemove: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffRemovedMethod: anObject [

	self visitDiffRemove: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffRemovedPackage: anObject [

	self visitDiffRemove: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffUpdate: anObject [

	self visitDiff: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffUpdatedClass: anObject [

	self visitDiffUpdate: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffUpdatedMethod: anObject [

	self visitDiffUpdate: anObject
]

{ #category : #visiting }
SPDiffVisitor >> visitDiffUpdatedPackage: anObject [

	self visitDiffUpdate: anObject
]
