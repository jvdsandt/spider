Class {
	#name : #SPRemovedClass,
	#superclass : #SPDiffRemove,
	#instVars : [
		'methodDiffs'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPRemovedClass >> accept: aVisitor [
	aVisitor visitDiffRemovedClass: self
]

{ #category : #internal }
SPRemovedClass >> calcMethodDiffs [

	| methods |
	
	methods := Set new.
	^ self oldObjects 
		inject: OrderedCollection new
		into: [ :coll :each |
			each spiderClass methodRefs do: [ :eachMethodRef |
				(methods includes: eachMethodRef method)
					ifFalse: [ 
						coll add: (SPRemovedMethod removed: (Array with: eachMethodRef)).
						methods add: eachMethodRef method ] ].
			coll ]
]

{ #category : #accessing }
SPRemovedClass >> methodDiffs [

	^ methodDiffs ifNil: [ methodDiffs := self calcMethodDiffs ]
]

{ #category : #accessing }
SPRemovedClass >> oldCategory [

	^ self oldObject category
]

{ #category : #accessing }
SPRemovedClass >> oldSpiderClass [

	^ self oldObject spiderClass
]
