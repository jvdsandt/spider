Class {
	#name : #SPFileTreeLibGitDiff,
	#superclass : #SPGitLibGitDiff,
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'as yet unclassified' }
SPFileTreeLibGitDiff >> isPackagePath: aPath [

	| dirName |

	dirName := aPath readStream upTo: $/.
	^ dirName endsWith: '.package'
]

{ #category : #'as yet unclassified' }
SPFileTreeLibGitDiff >> packageNameFromPath: aPath [

	| dirName |

	dirName := aPath readStream upTo: $/.
	^ dirName copyFrom: 1 to: (dirName lastIndexOf: $.) - 1
]
