Class {
	#name : #SPPackageJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPPackageJson >> renderClassRefs: aList on: json [

	| classJson |
	
	classJson := SPClassJson new.

	json array: [ 
		aList do: [ :each |
			json object: [ 
				classJson renderClassSummary: each spiderClass on: json.
				json key: 'category' value: each category ] ] ]
]

{ #category : #rendering }
SPPackageJson >> renderGitCommitSummary: aCommit on: aRenderer [

	SPGitCommitJson new
		renderCommitSummary: aCommit on: aRenderer
]

{ #category : #rendering }
SPPackageJson >> renderMCPackageSummary: mcPackage on: aRenderer [

	aRenderer 
		key: 'id' value: mcPackage id;
		key: 'name' value: mcPackage name;
		key: 'uuid' value: mcPackage uuid asString;
		key: 'version' value: mcPackage version;
		key: 'author' value: mcPackage author;
		key: 'datetime' value: mcPackage datetime;
		key: 'message' value: mcPackage message
]

{ #category : #rendering }
SPPackageJson >> renderPackage: aPackage on: aRenderer [

	| gitCommit mcPackage |
	
	gitCommit := aPackage oldestGitCommit.
	mcPackage := aPackage oldestMCPackage.

	aRenderer object: [ 
		aRenderer 
			key: 'id' value: aPackage id;
			key: 'name' value: aPackage name;
			key: 'classes' value: [ self renderClassRefs: aPackage classRefs on: aRenderer ];
			key: 'gitCommit' value: (gitCommit ifNotNil: [
				[ aRenderer object: [ self renderGitCommitSummary: gitCommit on: aRenderer ]	] ]);
			key: 'mcPackage' value: (mcPackage ifNotNil: [
				[ aRenderer object: [ self renderMCPackageSummary: mcPackage on: aRenderer ] ] ])
	]
]

{ #category : #rendering }
SPPackageJson >> renderPackageSummary: aPackage on: aRenderer [

	aRenderer
		key: 'id' value: aPackage id;
		key: 'name' value: aPackage name
]
