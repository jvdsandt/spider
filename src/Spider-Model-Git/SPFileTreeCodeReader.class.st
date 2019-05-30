Class {
	#name : #SPFileTreeCodeReader,
	#superclass : #SPCodeReader,
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'API-packages' }
SPFileTreeCodeReader >> getPackageSnapshot: aPackageName ifAbsent: aBlock [

	| ref |
	
	ref := fileReference / (aPackageName, '.package').
	ref exists
		ifFalse: [ ^ aBlock value ].
	
	^ (MCFileTreeStCypressReader on: fileReference)
			packageDirectory: ref basename;
			snapshot 
]

{ #category : #'API-packages' }
SPFileTreeCodeReader >> packageDirectories [

	^ (fileReference directoriesMatching: '*.package')
			select: [ :each | (each / '.filetree') exists ]
]

{ #category : #'API-packages' }
SPFileTreeCodeReader >> packageNames [

	^ self packageDirectories collect: [ :each | each basenameWithoutExtension ]
]
