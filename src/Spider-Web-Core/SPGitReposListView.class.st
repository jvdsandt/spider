Class {
	#name : #SPGitReposListView,
	#superclass : #SPListView,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPGitReposListView >> renderRow: item on: html [

	html tableRow: [ 
		html tableData: item domain.
		html tableData: item owner.
		html tableData: [
			html anchor
				url: (self router pathForGitRepo: item);
				with: 	item name ].
		html tableData: item lastDatetime ]

]

{ #category : #rendering }
SPGitReposListView >> renderTableBodyOn: html [

	self list do: [ :each |
		self renderRow: each on: html ]
]

{ #category : #rendering }
SPGitReposListView >> renderTableHeadOn: html [

	html tableHeading: 'url'.

]

{ #category : #accessing }
SPGitReposListView >> title [

	^ 'Git repositories'
]
