Class {
	#name : #LGitDirectoryEntry,
	#superclass : #FileSystemDirectoryEntry,
	#category : #'Spider-Pharo8-Support'
}

{ #category : #accessing }
LGitDirectoryEntry >> basename [

	^ reference basename
]

{ #category : #accessing }
LGitDirectoryEntry >> creationTime [

	^reference creationTime
]

{ #category : #accessing }
LGitDirectoryEntry >> deviceId [
	"Simulate the device id with the file systemss hash"

	^reference store hash
]

{ #category : #accessing }
LGitDirectoryEntry >> fileSize [
	"Simulate the device id with the file systems hash"

	^reference size
]

{ #category : #accessing }
LGitDirectoryEntry >> inode [
	"Simulate the inode with the file hash"

	^reference hash
]

{ #category : #accessing }
LGitDirectoryEntry >> isDirectory [

	^reference isDirectory
]

{ #category : #accessing }
LGitDirectoryEntry >> isFile [

	^reference isFile
]

{ #category : #accessing }
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

{ #category : #accessing }
LGitDirectoryEntry >> posixPermissions [
	"Answer the receivers posix permissions: Readonly"
	
	^8r444
]

{ #category : #accessing }
LGitDirectoryEntry >> size [ 
	^reference size
]
