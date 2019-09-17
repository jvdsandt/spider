Class {
	#name : #SPMonticelloRepoToPackageRef,
	#superclass : #SPGlorpRef,
	#instVars : [
		'filename',
		'mcPackage'
	],
	#category : #'Spider-Model-MC-Domains'
}

{ #category : #accessing }
SPMonticelloRepoToPackageRef >> datetime [

	^ self mcPackage datetime
]

{ #category : #accessing }
SPMonticelloRepoToPackageRef >> filename [
	^ filename
]

{ #category : #accessing }
SPMonticelloRepoToPackageRef >> mcPackage [
	^ mcPackage
]
