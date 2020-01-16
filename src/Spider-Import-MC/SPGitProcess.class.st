Class {
	#name : #SPGitProcess,
	#superclass : #Object,
	#instVars : [
		'directory',
		'url'
	],
	#category : #'Spider-Import-MC-Spider-Import-MC'
}

{ #category : #actions }
SPGitProcess >> clone [

	OSSUnixSubprocess new
		workingDirectory: self directory fullName;
		command: 'git';
		arguments: { 'clone'. '--bare'. self url };
		runAndWait
]

{ #category : #accessing }
SPGitProcess >> directory [
	^ directory
]

{ #category : #accessing }
SPGitProcess >> directory: anObject [
	directory := anObject
]

{ #category : #actions }
SPGitProcess >> fetch [

	OSSUnixSubprocess new
		workingDirectory: self directory fullName;
		command: 'git';
		arguments: #('fetch' '--prune-tags' 'origin' '+refs/heads/*:refs/heads/*');
		runAndWait
]

{ #category : #accessing }
SPGitProcess >> url [
	^ url
]

{ #category : #accessing }
SPGitProcess >> url: anObject [
	url := anObject
]
