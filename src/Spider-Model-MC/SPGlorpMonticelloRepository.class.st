Class {
	#name : #SPGlorpMonticelloRepository,
	#superclass : #SPGlorpNode,
	#instVars : [
		'repoUrl',
		'mcPackageRefs'
	],
	#category : #'Spider-Model-MC-Domains'
}

{ #category : #'instance creation' }
SPGlorpMonticelloRepository class >> repoUrl: anUrl packages: aMcPackageRefs [

	^ self new initWithRepoUrl: anUrl packages: aMcPackageRefs
]

{ #category : #initialization }
SPGlorpMonticelloRepository >> initWithRepoUrl: anUrl packages: aMcPackageRefs [

	repoUrl := anUrl.
	mcPackageRefs := aMcPackageRefs
]

{ #category : #accessing }
SPGlorpMonticelloRepository >> mcPackageRefs [
	^ mcPackageRefs
]

{ #category : #accessing }
SPGlorpMonticelloRepository >> repoUrl [
	^ repoUrl
]

{ #category : #accessing }
SPGlorpMonticelloRepository >> repoUrl: anObject [
	repoUrl := anObject
]
