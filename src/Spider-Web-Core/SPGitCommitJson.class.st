Class {
	#name : #SPGitCommitJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPGitCommitJson >> renderCommit: anItem on: aRenderer [

	aRenderer object: [ 
		self renderCommitSummary: anItem on: aRenderer.
		aRenderer key: 'parents' value: [ 
			aRenderer array: [ 
				anItem parents do: [ :each |
					aRenderer object: [ 
						self renderCommitSummary: each on: aRenderer ] ] ] ].
		aRenderer key: 'packages' value: [ self renderPackages: anItem packages on: aRenderer ]
		 ]
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
	aRenderer key: 'message' value: anItem message
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

	aRenderer
		key: 'id' value: aPackage id;
		key: 'name' value: aPackage name
]

{ #category : #rendering }
SPGitCommitJson >> renderPackages: aList on: aRenderer [

	aRenderer array: [ 
		aList do: [ :each | 
			aRenderer object: [
				self renderPackageSummary: each on: aRenderer ] ] ]
]