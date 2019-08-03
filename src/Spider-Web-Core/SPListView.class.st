Class {
	#name : #SPListView,
	#superclass : #SPComponent,
	#instVars : [
		'list'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPListView >> list [
	^ list
]

{ #category : #accessing }
SPListView >> list: anObject [
	list := anObject
]

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

	html table
		class: 'table table-striped table-bordered';
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
