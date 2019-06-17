Class {
	#name : #SPPage,
	#superclass : #SPComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPPage >> pageTitle [

	^ 'Spider'
]

{ #category : #rendering }
SPPage >> updateRoot: anHtmlRoot [
	super updateRoot: anHtmlRoot.
	
	anHtmlRoot beHtml5.
	anHtmlRoot title: self pageTitle..

	anHtmlRoot javascript
		url: (JQDeploymentLibrary urlOf: #jQueryJs).
		
	anHtmlRoot javascript
		url: (TBSDeploymentLibrary urlOf: #jsbootstrapminJs).
		
	anHtmlRoot stylesheet
		url: (TBSDeploymentLibrary urlOf: #cssbootstrapminCss).
		
		
	
]
