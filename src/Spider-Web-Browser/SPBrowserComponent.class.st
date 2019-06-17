Class {
	#name : #SPBrowserComponent,
	#superclass : #SPComponent,
	#instVars : [
		'browser',
		'packageListPanel',
		'classListPanel',
		'categoryListPanel',
		'methodListPanel',
		'sourcePanel'
	],
	#category : #'Spider-Web-Browser'
}

{ #category : #'instance creation' }
SPBrowserComponent class >> onGitCommit: aGitCommit [

	| browser |
	
	browser := SPBrowser onGitCommit: aGitCommit.
	^ self new
			browser: browser;
			yourself
]

{ #category : #'instance creation' }
SPBrowserComponent class >> onPackage: aPackage [

	| browser |
	
	browser := SPBrowser onPackage: aPackage.
	^ self new
			browser: browser;
			yourself
]

{ #category : #'instance creation' }
SPBrowserComponent class >> onPackages: aPackages [

	| browser |
	
	browser := SPBrowser onPackages: aPackages.
	^ self new
			browser: browser;
			yourself
]

{ #category : #accessing }
SPBrowserComponent >> browser [

	^ browser
]

{ #category : #accessing }
SPBrowserComponent >> browser: aBrowser [

	browser := aBrowser
]

{ #category : #accessing }
SPBrowserComponent >> categoryListPanel [

	^ categoryListPanel ifNil: [ 
			categoryListPanel := SPCategoryListPanel new
					browser: browser;
					methodListPanel: self methodListPanel;
					yourself ]
]

{ #category : #accessing }
SPBrowserComponent >> classListPanel [

	^ classListPanel ifNil: [ 
			classListPanel := SPClassListPanel new
					browser: browser;
					categoryListPanel: self categoryListPanel;
					yourself ]
]

{ #category : #initialization }
SPBrowserComponent >> initialize [

	super initialize.

]

{ #category : #accessing }
SPBrowserComponent >> methodListPanel [

	^ methodListPanel ifNil: [ 
			methodListPanel := SPMethodListPanel new
					browser: browser;
					sourcePanel: self sourcePanel;
					yourself ]
]

{ #category : #accessing }
SPBrowserComponent >> packageListPanel [

	^ packageListPanel ifNil: [ 
			packageListPanel := SPPackagesListPanel new
					browser: browser;
					classListPanel: self classListPanel;
					yourself ]
]

{ #category : #rendering }
SPBrowserComponent >> renderContentOn: html [

	self renderListsOn: html.
	self renderSourcePanelOn: html
]

{ #category : #rendering }
SPBrowserComponent >> renderListsOn: html [

	| id colSize |

	html tbsRow: [ 
		self browser packages size > 1
			ifTrue: [ 
				colSize := 3.
				html tbsColumn 
					id: (id := html nextId);
					mediumSize: colSize;
					with: [ 
						html render: (self packageListPanel 
							containerId: id;
							yourself) ] ]
			ifFalse: [
				colSize := 4 ].
		html tbsColumn 
			id: (id := html nextId);
			mediumSize: colSize;
			with: [ 
				html render: (self classListPanel 
					containerId: id;
					yourself) ].
		html tbsColumn 
			id: (id := html nextId);
			mediumSize: colSize;
			with: [ 
				html render: (self categoryListPanel
					containerId: id;
					yourself) ].
		html tbsColumn 
			id: (id := html nextId);
			mediumSize: colSize;
			with: [ 
				html render: (self methodListPanel
					containerId: id;
					yourself) ] ]
]

{ #category : #rendering }
SPBrowserComponent >> renderSourcePanelOn: html [

	| id |

	html tbsRow: [ 
		html tbsColumn 
			id: (id := html nextId);
			mediumSize: 12;
			with: [ 
				html render: (self sourcePanel 
					containerId: id;
					yourself) ] ]
]

{ #category : #accessing }
SPBrowserComponent >> sourcePanel [

	^ sourcePanel ifNil: [ 
			sourcePanel := SPSourcePanel new
				browser: self browser;
				yourself ]
]
