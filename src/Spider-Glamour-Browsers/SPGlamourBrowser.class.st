Class {
	#name : #SPGlamourBrowser,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #'instance creation' }
SPGlamourBrowser class >> openOnMagritte [

	| spiderContext |
	
	spiderContext := self sqliteMagritteContext.
		
	^ self new
			setContext: spiderContext;
			yourself
	
]

{ #category : #'instance creation' }
SPGlamourBrowser class >> openOnPharoDb [

	| spiderContext |
	
	spiderContext := self sqliteMagritteContext.
		
	^ self new
			setContext: spiderContext;
			finder
	
]

{ #category : #resources }
SPGlamourBrowser class >> sqliteMagritteContext [

	^ SPiderSQLiteContext openOnFile: '/tmp/magritte.db'
]

{ #category : #accessing }
SPGlamourBrowser >> context [
	^ context ifNil: [ context := SPWebContext default context ]
]

{ #category : #accessing }
SPGlamourBrowser >> diffRepo [
	^ context diffRepo
]

{ #category : #accessing }
SPGlamourBrowser >> gitRepo [
	^ context gitRepo
]

{ #category : #accessing }
SPGlamourBrowser >> packageRepo [
	^ context packageRepo
]

{ #category : #initialization }
SPGlamourBrowser >> setContext: aSPiderContext [

	context := aSPiderContext
]

{ #category : #accessing }
SPGlamourBrowser >> theme [
	^ Smalltalk ui theme
]
