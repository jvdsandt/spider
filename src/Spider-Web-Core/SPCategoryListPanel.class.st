Class {
	#name : #SPCategoryListPanel,
	#superclass : #SPListPanel,
	#instVars : [
		'methodListPanel'
	],
	#category : #'Spider-Web-Core-Browser'
}

{ #category : #accessing }
SPCategoryListPanel >> methodListPanel [
	^ methodListPanel
]

{ #category : #accessing }
SPCategoryListPanel >> methodListPanel: anObject [
	methodListPanel := anObject
]

{ #category : #rendering }
SPCategoryListPanel >> renderButtonsOn: html [

	html unorderedList 
		class: 'nav nav-pills';
		with: [ 
			html listItem 
				class: 'active' if: (self browser showInstance);
				with: [ 
					html anchor
						onClickDo: [ :s | self switchSide: s ];
						with: 'Instance' ].
			html listItem 
				class: 'active' if: (self browser showInstance not);
				with: [ 
					html anchor
						onClickDo: [ :s | self switchSide: s ];
						with: 'Class' ] ]
]

{ #category : #rendering }
SPCategoryListPanel >> renderContentOn: html [

	html select
		style: 'width: 100%;';
		size: 12;
		list: self browser categories.
		
	self renderButtonsOn: html
]

{ #category : #updating }
SPCategoryListPanel >> switchSide: script [

	self browser showInstance 
		ifTrue: [ self browser doShowClassSide ]
		ifFalse: [ self browser doShowInstanceSide ].
		
	self updateOn: script
]

{ #category : #updating }
SPCategoryListPanel >> updateOn: script [

	super updateOn: script.

	self methodListPanel updateOn: script
]
