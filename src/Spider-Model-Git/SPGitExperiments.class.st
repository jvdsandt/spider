Class {
	#name : #SPGitExperiments,
	#superclass : #Object,
	#instVars : [
		'context',
		'repository'
	],
	#category : #'Spider-Model-Git'
}

{ #category : #initialization }
SPGitExperiments >> initialize [

	super initialize.
	self openRepo
]

{ #category : #'as yet unclassified' }
SPGitExperiments >> masterBranch [

	^ repository localBranches first
]

{ #category : #'as yet unclassified' }
SPGitExperiments >> openRepo [

	repository := IceLibgitRepository new
		name: 'P3';
		location: 'D:\stdev\jvdsandt\P3' asFileReference;
		init;
		yourself.

]
