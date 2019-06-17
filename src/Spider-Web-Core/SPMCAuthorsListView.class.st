Class {
	#name : #SPMCAuthorsListView,
	#superclass : #SPListView,
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPMCAuthorsListView >> list [
	^ list ifNil: [ list := self queries allMCAuthorsByName ]
]

{ #category : #rendering }
SPMCAuthorsListView >> renderRow: row on: html [

	html tableRow: [ 
		html tableData: [ 
			html anchor
				callback: [ self openMCAuthor: row first ];
				with: row first ].
		row allButFirst do: [ :each |
			html tableData: each ] ]

]

{ #category : #rendering }
SPMCAuthorsListView >> renderTableBodyOn: html [

	self list do: [ :each |
		self renderRow: each on: html ]
]

{ #category : #rendering }
SPMCAuthorsListView >> renderTableHeadOn: html [

	html tableHeading: 'Author'.
	html tableHeading: 'Oldest'.
	html tableHeading: 'Latest'.
	html tableHeading: '#Versions'.

]

{ #category : #accessing }
SPMCAuthorsListView >> title [

	^ 'MC Authors'
]
