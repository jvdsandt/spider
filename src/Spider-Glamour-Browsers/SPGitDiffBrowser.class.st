Class {
	#name : #SPGitDiffBrowser,
	#superclass : #SPGlamourGitBrowser,
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #private }
SPGitDiffBrowser >> createBrowser [

	^ GLMCompositePresentation new tabulator 
			with: [ :t |
				t title: 'Spider Commit Diffs'.
				t 
					row: #diffTree.
				t transmit to: #diffTree; andShow: [ :composite | 
					composite tree
						display: [ :commit | commit diffs ];
						children: [ :diff | diff children ];
						format: [ :diff | diff name ];
						icon: [ :diff | self theme icons iconNamed: diff iconName ]
					
					 ] ]
]

{ #category : #private }
SPGitDiffBrowser >> openOn: aGitCommit [

	self createBrowser openOn: aGitCommit
]
