Class {
	#name : #SPDiffPrinter,
	#superclass : #SPDiffVisitor,
	#instVars : [
		'stream',
		'tabs'
	],
	#category : #'Spider-Model-Core-Diff'
}

{ #category : #resources }
SPDiffPrinter >> addedMarker [

	^ '(+)'
]

{ #category : #internal }
SPDiffPrinter >> doIndent [

	tabs timesRepeat: [ self stream tab ]
]

{ #category : #internal }
SPDiffPrinter >> indent [
	tabs := tabs + 1
]

{ #category : #initialization }
SPDiffPrinter >> initialize [

	super initialize.
	tabs := 0.
]

{ #category : #resources }
SPDiffPrinter >> removedMarker [

	^ '(-)'
]

{ #category : #accessing }
SPDiffPrinter >> stream [
	^ stream
]

{ #category : #accessing }
SPDiffPrinter >> stream: anObject [
	stream := anObject
]

{ #category : #accessing }
SPDiffPrinter >> tabs [
	^ tabs
]

{ #category : #accessing }
SPDiffPrinter >> tabs: anObject [
	tabs := anObject
]

{ #category : #internal }
SPDiffPrinter >> unindent [
	tabs := tabs - 1
]

{ #category : #resources }
SPDiffPrinter >> updateMarker [

	^ '(u)'
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffAddedClass: aDiff [

	self doIndent.
	self stream
		nextPutAll: self addedMarker; space;
		nextPutAll: aDiff newSpiderClass typeName;
		nextPutAll: ' ';
		nextPutAll: aDiff name;
		cr
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffAddedMethod: aDiff [

	self doIndent.
	self stream
		nextPutAll: self addedMarker; 
		nextPutAll: (aDiff newObject isClassSide 
			ifTrue: [ 'class' ]
			ifFalse: [ 'instance' ]);
		nextPutAll: ' method ';
		nextPutAll: aDiff name;
		cr
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffAddedPackage: aDiff [

	self doIndent.
	self stream
		nextPutAll: self addedMarker; 
		nextPutAll: ' package ';
		nextPutAll: aDiff name;
		cr
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffRemovedClass: aDiff [

	self doIndent.
	self stream
		nextPutAll: self removedMarker; space;
		nextPutAll: aDiff newSpiderClass typeName;
		nextPutAll: ' ';
		nextPutAll: aDiff name;
		cr
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffRemovedMethod: aDiff [

	self doIndent.
	self stream
		nextPutAll: self removedMarker; 
		nextPutAll: (aDiff oldObject isClassSide 
			ifTrue: [ 'class' ]
			ifFalse: [ 'instance' ]);
		nextPutAll: ' method ';
		nextPutAll: aDiff name;
		cr
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffRemovedPackage: aDiff [

	self doIndent.
	self stream
		nextPutAll: self removedMarker;
		nextPutAll: ' package ';
		nextPutAll: aDiff name;
		cr
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffUpdatedClass: aDiff [

	self doIndent.
	self stream
		nextPutAll: self updateMarker; space;
		nextPutAll: aDiff newSpiderClass typeName;
		nextPutAll: ' ';
		nextPutAll: aDiff name;
		cr.
		
	self indent.
	aDiff methodDiffs do: [ :each |
		each accept: self ].
	self unindent 
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffUpdatedMethod: aDiff [

	self doIndent.
	self stream
		nextPutAll: self updateMarker; space;
		nextPutAll: (aDiff newObject isClassSide 
			ifTrue: [ 'class' ]
			ifFalse: [ 'instance' ]);
		nextPutAll: ' method ';
		nextPutAll: aDiff name;
		cr
]

{ #category : #visiting }
SPDiffPrinter >> visitDiffUpdatedPackage: aDiff [

	self doIndent.
	self stream
		nextPutAll: '(o) package ';
		nextPutAll: aDiff name;
		cr.
		
	self indent.
	aDiff classDiffs do: [ :each |
		each accept: self ].
	self unindent 
]
