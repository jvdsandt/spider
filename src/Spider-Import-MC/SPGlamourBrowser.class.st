Class {
	#name : #SPGlamourBrowser,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Spider-Import-MC-Spider-Import-MC'
}

{ #category : #'instance creation' }
SPGlamourBrowser class >> openOnMagritte [

	| spiderContext |
	
	spiderContext := self sqliteMagritteContext.
		
	^ self new
			setContext: spiderContext;
			yourself
	
]

{ #category : #'instance creation' }
SPGlamourBrowser class >> openOnPharoDb [

	| spiderContext |
	
	spiderContext := self sqliteMagritteContext.
		
	^ self new
			setContext: spiderContext;
			finder
	
]

{ #category : #resources }
SPGlamourBrowser class >> sqliteMagritteContext [

	^ SPiderSQLiteContext openOnFile: '/tmp/magritte.db'
]

{ #category : #'as yet unclassified' }
SPGlamourBrowser >> browseMCPackages [
	"self openOnMagritte browseMCPackages"
	
	GLMCompositePresentation new tabulator with: [ :t |
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
				display: [ :mcPackage | mcPackage summaryString ] ].
			
		t transmit from: #classes; to: #source; andShow: [ :composite |
			composite text
				title: 'Class detais';
				display: [ :spiderClass | spiderClass  asString ] ].
			
		t transmit from: #methods; to: #source; andShow: [ :composite |
			composite pharoMethod
				title: 'Method source';
				display: [ :methodRef | methodRef method source ] ].
			
	];
	openOn: (self context mcPackageRepo getMCPackagesByDatetime: 1000)
]

{ #category : #accessing }
SPGlamourBrowser >> context [
	^ context
]

{ #category : #accessing }
SPGlamourBrowser >> finder [

	| finder |	
	finder := GLMFinder new.
	finder show: [ :a | a list display: [ :r | r getAllPackageNames ] ].
	
	finder openOn: self packageRepo
]

{ #category : #accessing }
SPGlamourBrowser >> packageRepo [
	^ context packageRepo
]

{ #category : #initialization }
SPGlamourBrowser >> setContext: aSPiderContext [

	context := aSPiderContext
]
