Class {
	#name : #LGitCommitStore,
	#superclass : #FileSystemStore,
	#instVars : [
		'commit'
	],
	#category : #'Spider-Pharo8-Support'
}

{ #category : #'instance creation' }
LGitCommitStore class >> on: aLGitCommit [ 
	
	^ self new
		commit: aLGitCommit;
		yourself
]

{ #category : #public }
LGitCommitStore >> basenameFromEntry: aLGitTreeEntry [ 
	
	^ aLGitTreeEntry filename
]

{ #category : #abstract }
LGitCommitStore >> basicCreationTimeOf: aLGitTreeEntry [ 
	
	^ commit time asDateAndTime
]

{ #category : #abstract }
LGitCommitStore >> basicEntry: directoryEntry path: aPath nodesDo: aBlock [
	
	directoryEntry entries do: [ :each | aBlock value: each ]
]

{ #category : #abstract }
LGitCommitStore >> basicIsDirectory: aNode [
	
	^ aNode object isTree
]

{ #category : #abstract }
LGitCommitStore >> basicIsFile: aLGitTreeEntry [ 
	
	^ aLGitTreeEntry object isBlob
]

{ #category : #'as yet unclassified' }
LGitCommitStore >> basicIsSymlink: aNode [
	^ false
]

{ #category : #'as yet unclassified' }
LGitCommitStore >> basicModificationTimeOf: aLGitTreeEntry [ 
	
	^ commit time asDateAndTime
]

{ #category : #'error signalling' }
LGitCommitStore >> basicOpen: path writable: aBoolean [ 
	
	^ self
		nodeAt: path
		ifPresent: [ :aMemoryFileSystemEntry | aMemoryFileSystemEntry ]
		ifAbsent: [ 
			aBoolean
				ifFalse: [ self signalFileDoesNotExist: path ]
				ifTrue: [ self createFile: path ] ]
]

{ #category : #'as yet unclassified' }
LGitCommitStore >> basicPosixPermissions: aLGitTreeEntry [ 
	
	^ 8r444
]

{ #category : #abstract }
LGitCommitStore >> basicSizeOf: aLGitTreeEntry [ 
	
	^ (self basicIsDirectory: aLGitTreeEntry)
		ifTrue: [ 0 ]
		ifFalse: [ aLGitTreeEntry object rawSize ]
]

{ #category : #accessing }
LGitCommitStore >> commit: anIceGitCommit [ 
	commit := anIceGitCommit
]

{ #category : #accessing }
LGitCommitStore >> delimiter [
	
	^ $/
]

{ #category : #public }
LGitCommitStore >> entryFromNode: node path: path for: aFilesystem [
	^LGitDirectoryEntry reference: (FileReference fileSystem: aFilesystem path: path).
]

{ #category : #printing }
LGitCommitStore >> forReferencePrintOn: aStream [
	
	aStream nextPutAll: 'git://'
]

{ #category : #accessing }
LGitCommitStore >> handleClass [
	
	^ LGitFileHandle
]

{ #category : #printing }
LGitCommitStore >> humanReadableSIByteSize [
	
	^ 0
]

{ #category : #printing }
LGitCommitStore >> nodeAt: anAbsolutePath ifPresent: aBlockClosure ifAbsent: aBlockClosure3 [ 
	
	anAbsolutePath isRoot ifTrue: [ ^ aBlockClosure value: commit tree ].	
	^ aBlockClosure value: (commit tree
		entryByPath: anAbsolutePath pathString
		ifAbsent: [ ^ aBlockClosure3 value ])
]
