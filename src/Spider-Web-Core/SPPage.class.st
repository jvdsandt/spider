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
		url: 'https://www.cloudctrl.com/files/jquery/3.4.1/jquery.min.js'.
		
	anHtmlRoot javascript
		url: 'https://www.cloudctrl.com/files/bootstrap/3.4.1/js/bootstrap.min.js'.
		
	anHtmlRoot stylesheet
		url: 'https://www.cloudctrl.com/files/bootstrap/3.4.1/css/bootstrap.min.css'
]
