Class {
	#name : #SPLibGitExperiments,
	#superclass : #Object,
	#category : #'Spider-Model-Git'
}

{ #category : #accessing }
SPLibGitExperiments >> read [

	| repo |
	
	repo := LGitRepository on: '/Users/jan/Projects/Ring2.git' asFileReference.
]

{ #category : #accessing }
SPLibGitExperiments >> readFileTreeDirectory [

	| gitRepo gitCommit gitFileSystem mcRepo |
	
	gitRepo := LGitRepository on: '/Users/jan/Projects/Ring2' asFileReference.
	gitRepo open.
	
	gitCommit := gitRepo head object.
	gitFileSystem := FileSystem onGitCommit: gitCommit.
	
	mcRepo := MCFileTreeRepository new
		directory: gitFileSystem / 'src';
		readonly: true;
		yourself.
		
	^ mcRepo allFileNames collect: [ :each | mcRepo versionFromFileNamed: each ]
]

{ #category : #accessing }
SPLibGitExperiments >> readTonelDirectory [

	| gitRepo gitCommit gitFileSystem mcRepo |
	
	gitRepo := LGitRepository on: '/Users/jan/Projects/Ring2' asFileReference.
	gitRepo open.
	
	gitCommit := gitRepo head object.
	gitFileSystem := FileSystem onGitCommit: gitCommit.
	
	mcRepo := TonelRepository new
		directory: gitFileSystem / 'src';
		yourself.
		
	^ mcRepo allFileNames collect: [ :each | mcRepo versionFromFileNamed: each ]
]
