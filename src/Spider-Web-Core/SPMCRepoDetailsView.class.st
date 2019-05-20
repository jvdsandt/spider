Class {
	#name : #SPMCRepoDetailsView,
	#superclass : #SPDetailsView,
	#instVars : [
		'mcRepo'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPMCRepoDetailsView >> mcPackageRefs [

	^ self mcRepo mcPackageRefs sorted: [ :p1 :p2 | p1 datetime > p2 datetime ]
]

{ #category : #accessing }
SPMCRepoDetailsView >> mcRepo [
	^ mcRepo
]

{ #category : #accessing }
SPMCRepoDetailsView >> mcRepo: anObject [
	mcRepo := anObject
]

{ #category : #rendering }
SPMCRepoDetailsView >> renderContentOn: html [

	self renderLabel: 'id' value: self mcRepo id on: html.
	
	html paragraph: [ 
		html text: 'Location: '.
		html anchor 
			url: self mcRepo repoUrl;
			target: '_blank';
			with: self mcRepo repoUrl ].
	
	self renderPackagesOn: html

]

{ #category : #rendering }
SPMCRepoDetailsView >> renderPackagesOn: html [

	html heading
		level: 4;
		with: 'Versions'.
		
	html tbsTable 
		beBordered;
		beStriped;
		with:  [ 
			html tableHead: [ 
				html tableHeading: 'Filename'.
				html tableHeading: 'Author'.
				html tableHeading: 'Timestamp' ].
			html tableBody: [ 
				self mcPackageRefs do: [ :each |
					html tableRow: [ self renderPackagesVersion: each on: html ] ] ] ].
]

{ #category : #rendering }
SPMCRepoDetailsView >> renderPackagesVersion: aMCPackageRef on: html [

	html tableData: [
		html anchor
			callback: [ self openMCPackage: aMCPackageRef mcPackage ];
			with: aMCPackageRef filename ].
	html tableData: aMCPackageRef mcPackage author.
	html tableData: aMCPackageRef mcPackage datetime
]
