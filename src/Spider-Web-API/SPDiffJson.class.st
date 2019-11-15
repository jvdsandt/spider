Class {
	#name : #SPDiffJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-API'
}

{ #category : #rendering }
SPDiffJson >> renderCommitDiff: aCommit on: aRenderer [

	| diffs |
	
	diffs := aCommit diffs.
	aRenderer object: [ 
		aRenderer key: 'diffs' value: [ 
			SPDiffToJsonVisitor new
				renderer: aRenderer;
				visitAll: diffs ] ]
]

{ #category : #rendering }
SPDiffJson >> renderCommitDiffBetween: newCommit and: oldCommit on: aRenderer [

	| diffs |
	
	diffs := newCommit comparePackagesWith: oldCommit.
	
	aRenderer object: [ 
		aRenderer key: 'diffs' value: [ 
			SPDiffToJsonVisitor new
				renderer: aRenderer;
				visitAll: diffs ] ]
]
