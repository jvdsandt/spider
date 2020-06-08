Class {
	#name : #SPTonelCodeReader,
	#superclass : #SPCodeReader,
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'API-packages' }
SPTonelCodeReader >> getPackageFileRef: aPackageName ifAbsent: aBlock [

	| ref |
	
	ref := fileReference / aPackageName.
	^ (ref exists and: [ self isPackageDirectory: ref ])
		ifTrue: [ ref ]
		ifFalse: [ aBlock value ]
]

{ #category : #'API-packages' }
SPTonelCodeReader >> getPackageSnapshot: aPackageName ifAbsent: aBlock [

	self getPackageFileRef: aPackageName ifAbsent: [ ^ aBlock value ].
	^ (TonelReader on: fileReference)
			packageDirectory: aPackageName;
			snapshot
]

{ #category : #'API-packages' }
SPTonelCodeReader >> isPackageDirectory: aFileRef [

	^ (aFileRef / 'package.st') exists
]

{ #category : #'API-packages' }
SPTonelCodeReader >> packageDirectories [

	^ fileReference directories select: [ :each | self isPackageDirectory: each ]
]

{ #category : #'API-packages' }
SPTonelCodeReader >> packageNames [

	^ self packageDirectories collect: [ :each | each basename ]
]
