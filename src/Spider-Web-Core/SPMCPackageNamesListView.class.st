Class {
	#name : #SPMCPackageNamesListView,
	#superclass : #SPListView,
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPMCPackageNamesListView >> list [
	^ list ifNil: [ self queries allMCPackageNamesByName ]
]

{ #category : #rendering }
SPMCPackageNamesListView >> renderRow: row on: html [

	html tableRow: [ 
		row do: [ :each |
			html tableData: each ] ]

]

{ #category : #rendering }
SPMCPackageNamesListView >> renderTableBodyOn: html [

	self list do: [ :each |
		self renderRow: each on: html ]
]

{ #category : #rendering }
SPMCPackageNamesListView >> renderTableHeadOn: html [

	html tableHeading: 'Package name'.
	html tableHeading: 'Oldest'.
	html tableHeading: 'Latest'.
	html tableHeading: '#Versions'.

]

{ #category : #accessing }
SPMCPackageNamesListView >> title [

	^ 'MC Packages'
]
