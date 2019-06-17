Class {
	#name : #SPMCRepoListView,
	#superclass : #SPListView,
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPMCRepoListView >> list [

	^ list ifNil: [ list := self queries allMCRepositories   ]
]

{ #category : #rendering }
SPMCRepoListView >> renderRow: mcRepo on: html [

	html tableData: [
		html anchor
			callback: [ self openMCRepo: mcRepo ];
			with: mcRepo repoUrl ]
]

{ #category : #rendering }
SPMCRepoListView >> renderTableBodyOn: html [

	self list do: [ :each |
		html tableRow: [  
			self renderRow: each on: html ] ]
]

{ #category : #rendering }
SPMCRepoListView >> renderTableHeadOn: html [

	html tableHeading: 'Repository'.

]

{ #category : #accessing }
SPMCRepoListView >> title [

	^ 'MC Repositories'
]
