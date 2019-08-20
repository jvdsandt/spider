Class {
	#name : #SPTestDataCore,
	#superclass : #Object,
	#category : #'Spider-Model-Core-Tests'
}

{ #category : #tests }
SPTestDataCore >> classBuilder [ 

	^ SPClassBuilder new
]

{ #category : #tests }
SPTestDataCore >> classExtensionBuilder [ 

	^ SPClassExtensionBuilder new
]

{ #category : #creating }
SPTestDataCore >> createClassAV1 [

	^ self classBuilder 
		name: #ClassA;
		addInstanceMethod: self createM1V1 category: 'accessing';
		addInstanceMethod: self createM2V1 category: 'accessing';
		addClassMethod: self createM3V1 category: 'resources';
		build

]

{ #category : #creating }
SPTestDataCore >> createClassAV2 [

	^ self classBuilder 
		name: #ClassA;
		addInstanceMethod: self createM1V2 category: 'accessing';
		addInstanceMethod: self createM2V1 category: 'accessing';
		addClassMethod: self createM3V1 category: 'resources';
		build

]

{ #category : #creating }
SPTestDataCore >> createClassBV1 [

	^ self classBuilder 
		name: #ClassA;
		addInstanceMethod: self createM2V1 category: 'accessing';
		addInstanceMethod: self createM4V1 category: 'calculating';
		build

]

{ #category : #creating }
SPTestDataCore >> createClassExtensionNumberV1 [

	^ self classExtensionBuilder 
		name: #Number;
		addInstanceMethod: self createM3V1 category: 'calculating';
		addInstanceMethod: self createM4V1 category: 'calculating';
		build

]

{ #category : #creating }
SPTestDataCore >> createM1V1 [

	^ self methodBuilder
		setSource: 'method1
	^ ''firstInplementation''';
		build
]

{ #category : #creating }
SPTestDataCore >> createM1V2 [

	^ self methodBuilder
		setSource: 'method1
	^ ''secondImplementation''' + 1234;
		build
]

{ #category : #creating }
SPTestDataCore >> createM2V1 [

	^ self methodBuilder
		setSource: 'method2: anArgument
	| tempA |
	^ tempA * 123.45';
		build
]

{ #category : #creating }
SPTestDataCore >> createM3V1 [

	^ self methodBuilder
		setSource: 'method3: arg1 and: arg2
	| tempA |
	tempA := 1.0.
	^ tempA * arg1 + arg2';
		build
]

{ #category : #creating }
SPTestDataCore >> createM4V1 [

	^ self methodBuilder
		setSource: 'method4
	^ theVariable + 123';
		build
]

{ #category : #creating }
SPTestDataCore >> createPackageAV1 [

	^ self packageBuilder 
		name: 'PackageA';
		addClass: self createClassAV1 category: nil;
		addClass: self createClassBV1 category: nil;
		build
]

{ #category : #creating }
SPTestDataCore >> createPackageAV2 [

	^ self packageBuilder 
		name: 'PackageA';
		addClass: self createClassAV1 category: nil;
		addClass: self createClassBV1 category: nil;
		addClassExtension: self createClassExtensionNumberV1;
		build
]

{ #category : #tests }
SPTestDataCore >> methodBuilder [ 

	^ SPMethodBuilder new
]

{ #category : #tests }
SPTestDataCore >> packageBuilder [ 

	^ SPPackageBuilder new
]
