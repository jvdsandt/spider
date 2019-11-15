Class {
	#name : #SPMonticelloPackageJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-API'
}

{ #category : #rendering }
SPMonticelloPackageJson >> renderPackageItem: mcPackage on: aRenderer [

	aRenderer object: [ 
		aRenderer 
			key: 'id' value: mcPackage id;
			key: 'name' value: mcPackage name;
			key: 'uuid' value: mcPackage uuid asString;
			key: 'version' value: mcPackage version;
			key: 'author' value: mcPackage author;
			key: 'datetime' value: mcPackage datetime;
			key: 'message' value: mcPackage message;
			key: 'packageId' value: (mcPackage package ifNotNil: [ :p | p id ]);
			key: 'ancestorIds' value: (mcPackage ancestors collect: [ :each | each id ])	]
]

{ #category : #rendering }
SPMonticelloPackageJson >> renderRepoPackageList: aList more: hasMore on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'list' value: [ 
			aRenderer array: [ 
				aList do: [ :each |
					self renderRepoPackageRef: each on: aRenderer ] ].
		aRenderer key: 'hasMore' value: hasMore ] ]
]

{ #category : #rendering }
SPMonticelloPackageJson >> renderRepoPackageRef: mcPackageRef on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'filename' value: mcPackageRef filename.
		aRenderer key: 'mcPackage' value: [ 
			self renderPackageItem: mcPackageRef mcPackage on: aRenderer ] ]
		
]
