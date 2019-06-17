Class {
	#name : #SPDiffsComponent,
	#superclass : #SPComponent,
	#instVars : [
		'diffs'
	],
	#category : #'Spider-Web-Core-Diff'
}

{ #category : #accessing }
SPDiffsComponent >> diffs [
	^ diffs
]

{ #category : #accessing }
SPDiffsComponent >> diffs: anObject [
	diffs := anObject
]

{ #category : #accessing }
SPDiffsComponent >> renderAddedClass: aDiff on: html [

	html heading
		level: 4;
		with: 'Added class ', aDiff name.

]

{ #category : #accessing }
SPDiffsComponent >> renderAddedMethod: aDiff on: html [

	html heading
		level: 4;
		with: 'Added method ', aDiff selector.

]

{ #category : #accessing }
SPDiffsComponent >> renderAddedPackage: aDiff on: html [

	html heading
		level: 4;
		with: 'Added package ', aDiff name.

	aDiff classDiffs do: [ :each |
		self renderDiff: each on: html ]
]

{ #category : #rendering }
SPDiffsComponent >> renderContentOn: html [

	self diffs do: [ :each |
		html div: [ self renderDiff: each on: html ] ]
]

{ #category : #rendering }
SPDiffsComponent >> renderDiff: aDiff on: html [

	aDiff accept: (SPDiffRenderer new
			component: self;
			canvas: html;
			yourself)
]

{ #category : #accessing }
SPDiffsComponent >> renderRemovedClass: aDiff on: html [

	html heading
		level: 4;
		with: 'Removed class ', aDiff name.

]

{ #category : #accessing }
SPDiffsComponent >> renderRemovedMethod: aDiff on: html [

	html heading
		level: 4;
		with: 'Removed method ', aDiff selector.

]

{ #category : #accessing }
SPDiffsComponent >> renderRemovedPackage: aDiff on: html [

	html heading
		level: 4;
		with: 'Removed package ', aDiff name.

]

{ #category : #accessing }
SPDiffsComponent >> renderUpdatedClass: aDiff on: html [

	html heading
		level: 4;
		with: 'Update class ', aDiff name.
		
	aDiff methodDiffs do: [ :each |
		self renderDiff: each on: html ]

]

{ #category : #accessing }
SPDiffsComponent >> renderUpdatedMethod: aDiff on: html [

	html heading
		level: 4;
		with: 'Update method ', aDiff selector.

]

{ #category : #accessing }
SPDiffsComponent >> renderUpdatedPackage: aDiff on: html [

	html heading
		level: 4;
		with: 'Update package ', aDiff name.

	aDiff classDiffs do: [ :each |
		self renderDiff: each on: html ]
]
