Class {
	#name : #SPPackageBrowser,
	#superclass : #SPGlamourBrowser,
	#instVars : [
		'packagesCriteria',
		'packagesLimit'
	],
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #private }
SPPackageBrowser >> createBrowser [

	^ GLMCompositePresentation new tabulator 
			with: [ :t |
				t title: 'Spider Package Browser'.
				t 
					column: #packages;
					column: #editions.
				t transmit to: #packages; andShow: [ :composite | 
					composite list
						format: [ :p | p ] ].
				t transmit to: #packages; from: #editions; andShow: [ :composite |
					composite list
						 ] ]
]

{ #category : #initialization }
SPPackageBrowser >> initialize [

	packagesLimit := 10000.
	packagesCriteria := SPStringSearchCriteria new
		term: '';
		caseSensitive: false;
		wildcardAfter: true;
		yourself
]

{ #category : #private }
SPPackageBrowser >> open [

	| list |
	
	list := self context packageRepo getPackageNames: self packagesCriteria max: self packagesLimit. 
	self createBrowser openOn: list
]

{ #category : #accessing }
SPPackageBrowser >> packagesCriteria [
	^ packagesCriteria
]

{ #category : #accessing }
SPPackageBrowser >> packagesCriteria: anObject [
	packagesCriteria := anObject
]

{ #category : #accessing }
SPPackageBrowser >> packagesLimit [
	^ packagesLimit
]

{ #category : #accessing }
SPPackageBrowser >> packagesLimit: anInteger [
	packagesLimit := anInteger
]
