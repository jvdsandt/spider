Class {
	#name : #SPMCRepoBrowser,
	#superclass : #SPGlamourBrowser,
	#category : #'Spider-Glamour-Browsers'
}

{ #category : #'as yet unclassified' }
SPMCRepoBrowser >> createBrowser [
	
	^ GLMCompositePresentation new tabulator with: [ :t |
		t title: 'Spider - Monticello package browser'.
		t 
			row: [:r | r column: #packages; column: #classes; column: #methods];
			row: #source.
			
		t transmit to: #packages; andShow: [ :composite | 
			composite list
				title: 'Packages';
				format: [ :each | each fullName ] ].
			
		t transmit from: #packages; to: #classes; andShow: [ :composite |
			composite list 
				title: 'Classes';
				display: [ :mcPackage | mcPackage package classRefs ];
				format: [ :elem | elem name ] ].
			
		t transmit from: #classes; to: #methods; andShow: [ :composite |
			composite list 
				title: 'Methods';
				display: [ :ref | ref spiderClass instanceMethodRefs ];
				format: [ :elem | elem selector ] ].
			
		t transmit from: #packages; to: #source; andShow: [ :composite |
			composite text
				title: 'Package details';
				display: [ :mcPackage | mcPackage name ] ].
			
		t transmit from: #classes; to: #source; andShow: [ :composite |
			composite text
				title: 'Class detais';
				display: [ :spiderClass | spiderClass  asString ] ].
			
		t transmit from: #methods; to: #source; andShow: [ :composite |
			composite pharoMethod
				title: 'Method source';
				display: [ :methodRef | methodRef method source ] ] ]
]

{ #category : #'as yet unclassified' }
SPMCRepoBrowser >> open [

	| list |
	
	list := self context mcPackageRepo getMCPackagesByDatetime: 1000.
	self createBrowser openOn: list
]
