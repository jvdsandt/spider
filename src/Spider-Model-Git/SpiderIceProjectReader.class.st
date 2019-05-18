Class {
	#name : #SpiderIceProjectReader,
	#superclass : #IceProjectReader,
	#instVars : [
		'sourceDirectory',
		'writerClass'
	],
	#category : #'Spider-Model-Git-Ice'
}

{ #category : #testing }
SpiderIceProjectReader >> canReadProjectFromCommitish: aCommitish [

	| candidateDirs filesystem |

	filesystem := aCommitish fileSystem.
	candidateDirs := #( '' 'src' ).
	
	candidateDirs do: [ :each |
		(filesystem / each / '.filetree') exists
			ifTrue: [ 
				sourceDirectory := each.
				writerClass := IceLibgitFiletreeWriter.
				^ true ] ].
				
	candidateDirs do: [ :each |
		((filesystem / each) isDirectory and: [ ((filesystem / each) childrenMatching: '*.package') notEmpty ])
			ifTrue: [ 
				sourceDirectory := each.
				writerClass := IceLibgitFiletreeWriter.
				^ true ] ].


	^ false
]

{ #category : #accessing }
SpiderIceProjectReader >> priority [

	^ 1000
]

{ #category : #testing }
SpiderIceProjectReader >> readProjectFromCommitish: aCommitish [

	^ (SpiderIceProject onCommitish: aCommitish)
			sourceDirectory: sourceDirectory;
			writerClass: writerClass;
			yourself
]
