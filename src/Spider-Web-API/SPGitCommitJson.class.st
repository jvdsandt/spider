Class {
	#name : #SPGitCommitJson,
	#superclass : #SPJsonComponent,
	#instVars : [
		'repo',
		'repoRefs'
	],
	#category : #'Spider-Web-API'
}

{ #category : #accessing }
SPGitCommitJson >> branchNames [

	^ (self repoRefs select: [ :each | each isBranch ])
			collect: [ :each | each name ]
]

{ #category : #rendering }
SPGitCommitJson >> renderBranchRef: aCommitRef from: aRepo on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'name' value: aCommitRef name.
		aRenderer key: 'commit' value: [
			self renderCommit: aCommitRef commit from: aRepo on: aRenderer ] ].
]

{ #category : #rendering }
SPGitCommitJson >> renderCommit: anItem from: aRepo on: aRenderer [

	self repo: aRepo.
	self renderCommit: anItem on: aRenderer
]

{ #category : #rendering }
SPGitCommitJson >> renderCommit: anItem on: aRenderer [

	aRenderer object: [ 
		self renderCommitSummary: anItem on: aRenderer.
		aRenderer key: 'message' value: anItem message.
		aRenderer key: 'parents' value: [ 
			aRenderer array: [ 
				anItem parents do: [ :each |
					aRenderer object: [ 
						self renderCommitSummary: each on: aRenderer ] ] ] ].
		aRenderer key: 'children' value: [ 
			aRenderer array: [ 
				anItem children do: [ :each |
					aRenderer object: [ 
						self renderCommitSummary: each on: aRenderer ] ] ] ].
		aRenderer key: 'packages' value: [ self renderPackages: anItem packages on: aRenderer ].
		self repo notNil
			ifTrue: [ 
				aRenderer key: 'repo' value: [ 
					SPGitRepoJson new renderItem: self repo on: aRenderer ].
				aRenderer key: 'tags' value: self tagNames.
				aRenderer key: 'branches' value: self branchNames ] ]
]

{ #category : #rendering }
SPGitCommitJson >> renderCommitList: aList on: aRenderer [

	aRenderer array: [ 
		aList do: [ :each |
			aRenderer object: [ 
				self renderCommitSummary: each on: aRenderer ] ] ]
]

{ #category : #rendering }
SPGitCommitJson >> renderCommitSummary: anItem on: aRenderer [

	aRenderer key: 'id' value: anItem id.
	aRenderer key: 'sha' value: anItem shaString.
	aRenderer key: 'datetime' value: anItem datetime.
	aRenderer key: 'authorName' value: anItem authorName.
	aRenderer key: 'messageLine' value: anItem messageLine.
	aRenderer key: 'rootId' value: anItem rootId
]

{ #category : #rendering }
SPGitCommitJson >> renderItem: anItem on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'sha' value: anItem shaString.
		aRenderer key: 'datetime' value: anItem datetime.
		aRenderer key: 'message' value: anItem message.
		aRenderer key: 'packages' value: [ self renderPackages: anItem packages on: aRenderer ]
		 ]
]

{ #category : #rendering }
SPGitCommitJson >> renderPackageSummary: aPackage on: aRenderer [

	SPPackageJson new
		package: aPackage;
		renderPackageSummaryOn: aRenderer 
]

{ #category : #rendering }
SPGitCommitJson >> renderPackages: aList on: aRenderer [

	aRenderer array: [ 
		aList do: [ :each | 
			aRenderer object: [
				self renderPackageSummary: each on: aRenderer ] ] ]
]

{ #category : #rendering }
SPGitCommitJson >> renderTagRef: aCommitRef from: aRepo on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'name' value: aCommitRef name.
		aRenderer key: 'commit' value: [
			self renderCommit: aCommitRef commit from: aRepo on: aRenderer ] ].
]

{ #category : #accessing }
SPGitCommitJson >> repo [
	^ repo
]

{ #category : #accessing }
SPGitCommitJson >> repo: anObject [
	repo := anObject
]

{ #category : #accessing }
SPGitCommitJson >> repoRefs [
	^ repoRefs
]

{ #category : #accessing }
SPGitCommitJson >> repoRefs: anObject [
	repoRefs := anObject
]

{ #category : #accessing }
SPGitCommitJson >> tagNames [

	^ (self repoRefs select: [ :each | each isTag ])
			collect: [ :each | each name ]
]
