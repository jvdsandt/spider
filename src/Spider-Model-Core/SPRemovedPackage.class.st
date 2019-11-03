Class {
	#name : #SPRemovedPackage,
	#superclass : #SPDiffRemove,
	#instVars : [
		'classDiffs'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPRemovedPackage >> accept: aVisitor [
	aVisitor visitDiffRemovedPackage: self
]

{ #category : #internal }
SPRemovedPackage >> calcClassDiffs [

	| classes |
	
	classes := Set new.
	^ self oldObjects 
		inject: OrderedCollection new
		into: [ :coll :each |
			each classRefs do: [ :eachClassRef |
				(classes includes: eachClassRef spiderClass	)
					ifFalse: [ 
						coll add: (SPRemovedClass removed: (Array with: eachClassRef)).
						classes add: eachClassRef spiderClass ] ].
			coll ]
]

{ #category : #accessing }
SPRemovedPackage >> classDiffs [

	^ classDiffs ifNil: [ classDiffs := self calcClassDiffs ]
]
