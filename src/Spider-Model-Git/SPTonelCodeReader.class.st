Class {
	#name : #SPTonelCodeReader,
	#superclass : #SPCodeReader,
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'API-packages' }
SPTonelCodeReader >> getPackageSnapshot: aPackageName ifAbsent: aBlock [

	| ref |
	
	ref := fileReference / aPackageName.
	ref exists
		ifFalse: [ ^ aBlock value ].
	
	^ (TonelReader on: fileReference)
			packageDirectory: aPackageName;
			snapshot
]

{ #category : #'API-packages' }
SPTonelCodeReader >> packageDirectories [

	^ fileReference directories select: [ :each | (each / 'package.st') exists ]
]

{ #category : #'API-packages' }
SPTonelCodeReader >> packageNames [

	^ self packageDirectories collect: [ :each | each basename ]
]
