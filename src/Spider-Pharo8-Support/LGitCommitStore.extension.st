Extension { #name : #LGitCommitStore }

{ #category : #'*Spider-Pharo8-Support' }
LGitCommitStore >> entryFromNode: node path: path for: aFileSystem [

	| entryPath |
	entryPath := path / (self basenameFromEntry: node).
	^ LGitDirectoryEntry 
			reference: (FileReference fileSystem: aFileSystem path: entryPath)
]
