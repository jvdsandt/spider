Class {
	#name : #SPListView,
	#superclass : #SPComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPListView >> renderContentOn: html [

	self renderTitle: self title on: html. 

	self renderTableOn: html
]

{ #category : #rendering }
SPListView >> renderTableBodyOn: html [


]

{ #category : #rendering }
SPListView >> renderTableHeadOn: html [


]

{ #category : #rendering }
SPListView >> renderTableOn: html [

	html tbsTable
		beStriped;
		beBordered;
		with: [ 
			html tableHead: [ self renderTableHeadOn: html ].
			html tableBody: [ self renderTableBodyOn: html ] ]
]

{ #category : #rendering }
SPListView >> renderTitle: aString on: html [

	html heading
		level: 3;
		with: aString
]

{ #category : #accessing }
SPListView >> title [

	^ self class name
]

{ #category : #accessing }
SPListView >> updateRoot: anHtmlRoot [

	super updateRoot: anHtmlRoot.
	
	anHtmlRoot title: self title
]
