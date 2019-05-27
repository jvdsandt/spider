Class {
	#name : #SPFileTreeCodeReader,
	#superclass : #SPCodeReader,
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'API-packages' }
SPFileTreeCodeReader >> getPackageSnapshot: aPackageName [

	| ref |
	
	^ (MCFileTreeStCypressReader on: fileReference)
		packageDirectory: aPackageName, '.package';
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
