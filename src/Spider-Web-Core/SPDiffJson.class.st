Class {
	#name : #SPDiffJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-Core'
}

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
