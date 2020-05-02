Class {
	#name : #SPRemovedMethod,
	#superclass : #SPDiffRemove,
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #visiting }
SPRemovedMethod >> accept: aVisitor [
	aVisitor visitDiffRemovedMethod: self
]

{ #category : #testing }
SPRemovedMethod >> isClassSide [
	^ self oldObject isClassSide 
]

{ #category : #accessing }
SPRemovedMethod >> name [
	^ self selector
]

{ #category : #accessing }
SPRemovedMethod >> oldCategory [

	^ self oldObject category
]

{ #category : #accessing }
SPRemovedMethod >> oldMethod [

	^ self oldObject method
]

{ #category : #accessing }
SPRemovedMethod >> oldSource [

	^ String streamContents: [ :s |
			s
				nextPut: $"; nextPutAll: self oldCategory; nextPut: $"; cr;
				nextPutAll: self oldMethod source ]
]

{ #category : #accessing }
SPRemovedMethod >> selector [

	^ self oldObject selector
]
