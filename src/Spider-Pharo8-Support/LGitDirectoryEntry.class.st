Class {
	#name : #LGitDirectoryEntry,
	#superclass : #FileSystemDirectoryEntry,
	#category : #'Spider-Pharo8-Support'
}

{ #category : #accessing }
LGitDirectoryEntry >> creationTime [

	^reference creationTime
]

{ #category : #accessing }
LGitDirectoryEntry >> fileSize [
	"Simulate the device id with the file systems hash"

	^reference fileSize
]

{ #category : #testing }
LGitDirectoryEntry >> isDirectory [

	^reference isDirectory
]

{ #category : #testing }
LGitDirectoryEntry >> isFile [

	^reference isFile
]

{ #category : #testing }
LGitDirectoryEntry >> isReadable [

	^true
]

{ #category : #accessing }
LGitDirectoryEntry >> isWritable [

	^false
]

{ #category : #accessing }
LGitDirectoryEntry >> modificationTime [

	^reference modificationTime
]

{ #category : #testing }
LGitDirectoryEntry >> posixPermissions [
	"Answer the receivers posix permissions.
	The memory file system doesn't have any access controls"
	
	^8r444
]

{ #category : #testing }
LGitDirectoryEntry >> size [ 
	^reference size
]
