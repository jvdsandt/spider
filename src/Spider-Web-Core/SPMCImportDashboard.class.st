Class {
	#name : #SPMCImportDashboard,
	#superclass : #SPPage,
	#instVars : [
		'mainPanel'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #'tools registry' }
SPMCImportDashboard class >> register [

	| app |
	
	app := WAAdmin register: self asApplicationAt: 'spider'.
	app addFilter: SPContextFilter new

	

]

{ #category : #hooks }
SPMCImportDashboard >> children [

	^ Array with: mainPanel 
]

{ #category : #hooks }
SPMCImportDashboard >> initialRequest: aRequest [
	super initialRequest: aRequest.
]

{ #category : #'as yet unclassified' }
SPMCImportDashboard >> initialize [

	super initialize.
	
	self returnHome
]

{ #category : #rendering }
SPMCImportDashboard >> openImportLog [

	mainPanel := SPLatestImportsView new
]

{ #category : #rendering }
SPMCImportDashboard >> openMCAuthors [

	mainPanel := SPMCAuthorsListView new
]

{ #category : #rendering }
SPMCImportDashboard >> openMCPackages [

	mainPanel := SPMCPackageNamesListView new
]

{ #category : #rendering }
SPMCImportDashboard >> openMCRepos [

	mainPanel := SPMCRepoListView new
]

{ #category : #rendering }
SPMCImportDashboard >> renderContentOn: html [

	self renderNavigationbarOn: html.

	html tbsContainer: [ 
		html render: mainPanel ]
		
	
]

{ #category : #rendering }
SPMCImportDashboard >> renderNavBarToggle: aTargetId on: html [

	html button
		class: 'navbar-toggle collapsed';
		attributeAt: 'data-toggle' put: 'collapse';
		attributeAt: 'data-target' put: '#', aTargetId;
		with: [ 
			html span class: 'sr-only'; with: 'Toggle navigation'.
			3 timesRepeat: [ html span class: 'icon-bar'; with: '' ] ]
]

{ #category : #rendering }
SPMCImportDashboard >> renderNavigationbarOn: html [
	
	html tbsNavbar beDefault; with: [ 
		html tbsContainer: [ 
			html tbsNavbarHeader: [ 
				self renderNavBarToggle: 'navbar-collapse' on: html.
				html tbsNavbarBrand
					callback: [ self returnHome ];
					with: self title ].	

			html div
				id: 'navbar-collapse';
				class: 'collapse navbar-collapse';
				with: [
					html tbsNav
						class: 'navbar-nav';
						with: [ 
						html listItem: [ 
							html anchor
								callback: [ self openImportLog ];
								with: 'Import log' ].
						html listItem: [ 
							html anchor
								callback: [ self openMCRepos ];
								with: 'Repositories' ].
						html listItem: [ 
							html anchor
								callback: [ self openMCPackages ];
								with: 'Packages' ].
						html listItem: [ 
							html anchor
								callback: [ self openMCAuthors ];
								with: 'Authors' ] ] ] ] ]
]

{ #category : #'as yet unclassified' }
SPMCImportDashboard >> returnHome [

	mainPanel := SPTransactionsListView new
]

{ #category : #updating }
SPMCImportDashboard >> title [

	^ 'Spider MC Import Dashboard'
]
