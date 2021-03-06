Class {
	#name : #SPPackageNameJson,
	#superclass : #SPJsonNameInfoComponent,
	#category : #'Spider-Web-API'
}

{ #category : #rendering }
SPPackageNameJson >> renderContentOn: aRenderer [

	self renderPackageOn: aRenderer
]

{ #category : #rendering }
SPPackageNameJson >> renderPackageOn: json [

	json object: [ 
		json 
			key: 'name' value: info name;
			key: 'versionCount' value: info versionCount;
			key: 'gitRepos' value: [ self renderGitReposOn: json ];
			key: 'gitAuthors' value: [ self renderGitAuthorsOn: json ];
			key: 'oldestGitCommit' value: [ 
					info oldestGitCommit 
						ifNil: [ json null ]
						ifNotNil: [ :c | json object: [ self renderGitCommitSummary: c on: json  ] ] ];
			key: 'newestGitCommit' value: [ 
					info newestGitCommit 
						ifNil: [ json null ]
						ifNotNil: [ :c | json object: [ self renderGitCommitSummary: c on: json  ] ] ];
			key: 'mcRepos' value: [ self renderMCReposOn: json ];
			key: 'mcAuthors' value: [ self renderMCAuthorsOn: json ];
			key: 'oldestMCPackage' value: [ 
					info oldestMCPackage 
						ifNil: [ json null ]
						ifNotNil: [ :c | json object: [ self renderMCPackageSummary: c on: json  ] ] ];
			key: 'newestMCPackage' value: [ 
					info newestMCPackage 
						ifNil: [ json null ]
						ifNotNil: [ :c | json object: [ self renderMCPackageSummary: c on: json  ] ] ]
	]
]
