Class {
	#name : #SPGlorpMonticelloRepoToPackageRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'filename',
		'mcPackage'
	],
	#category : #'Spider-Model-MC-Domains'
}

{ #category : #accessing }
SPGlorpMonticelloRepoToPackageRef >> datetime [

	^ self mcPackage datetime
]

{ #category : #accessing }
SPGlorpMonticelloRepoToPackageRef >> filename [
	^ filename
]

{ #category : #accessing }
SPGlorpMonticelloRepoToPackageRef >> mcPackage [
	^ mcPackage
]
