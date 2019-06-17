Class {
	#name : #SPDefaultRESTPage,
	#superclass : #SPComponent,
	#instVars : [
		'contentPanel'
	],
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPDefaultRESTPage >> contentPanel [
	^ contentPanel
]

{ #category : #accessing }
SPDefaultRESTPage >> contentPanel: anObject [
	contentPanel := anObject
]

{ #category : #rendering }
SPDefaultRESTPage >> renderContentOn: html [

	html tbsContainer: [ html render: self contentPanel ]
]

{ #category : #rendering }
SPDefaultRESTPage >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	anHtmlRoot beHtml5.
	anHtmlRoot title: 'Spider'.

	anHtmlRoot javascript
		url: (JQDeploymentLibrary urlOf: #jQueryJs).
		
	anHtmlRoot javascript
		url: (TBSDeploymentLibrary urlOf: #jsbootstrapminJs).
		
	anHtmlRoot stylesheet
		url: (TBSDeploymentLibrary urlOf: #cssbootstrapminCss).
		
		
	
]
