Class {
	#name : #SPPackageNamesListView,
	#superclass : #SPListView,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPPackageNamesListView >> renderRow: row on: html [

	html tableRow: [ 
			html tableData: row ]

]

{ #category : #rendering }
SPPackageNamesListView >> renderTableBodyOn: html [

	self list do: [ :each |
		self renderRow: each on: html ]
]

{ #category : #rendering }
SPPackageNamesListView >> renderTableHeadOn: html [

	html tableHeading: 'Package name'.

]

{ #category : #accessing }
SPPackageNamesListView >> title [

	^ 'Packages'
]
