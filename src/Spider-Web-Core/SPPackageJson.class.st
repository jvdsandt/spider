Class {
	#name : #SPPackageJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-Core'
}

{ #category : #rendering }
SPPackageJson >> renderClassRefs: aList on: json [

	| classJson |
	
	classJson := SPClassJson new.

	json array: [ 
		aList do: [ :each |
			json object: [ 
				classJson renderClassSummary: each spiderClass on: json.
				json key: 'category' value: each category ] ] ]
]

{ #category : #rendering }
SPPackageJson >> renderPackage: aPackage on: aRenderer [

	aRenderer object: [ 
		aRenderer 
			key: 'id' value: aPackage id;
			key: 'name' value: aPackage name;
			key: 'classes' value: [ self renderClassRefs: aPackage classRefs on: aRenderer ]
			
		 ]
]

{ #category : #rendering }
SPPackageJson >> renderPackageSummary: aPackage on: aRenderer [

	aRenderer
		key: 'id' value: aPackage id;
		key: 'name' value: aPackage name
]
