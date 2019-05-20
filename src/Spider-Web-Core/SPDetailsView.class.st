Class {
	#name : #SPDetailsView,
	#superclass : #SPComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPDetailsView >> renderLabel: aString value: aValue on: html [

	html paragraph: [ 
		html text: aString; text: ': '.
		html strong: aValue ]
]

{ #category : #rendering }
SPDetailsView >> renderTitle: aString on: html [

	html heading
		level: 3;
		with: aString
]
