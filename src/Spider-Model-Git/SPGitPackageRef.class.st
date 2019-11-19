"
To speed up the Git import process I cache the sha hash value of the git tree that represents a package.
"
Class {
	#name : #SPGitPackageRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'shaBytes',
		'package'
	],
	#category : #'Spider-Model-Git-Domain'
}

{ #category : #accessing }
SPGitPackageRef >> package [
	^ package
]

{ #category : #accessing }
SPGitPackageRef >> shaBytes [
	^ shaBytes
]
