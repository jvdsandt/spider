Class {
	#name : #SPMonticelloRepoJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-API'
}

{ #category : #rendering }
SPMonticelloRepoJson >> renderDetails: mcRepo on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'id' value: mcRepo id.
		aRenderer key: 'repoUrl' value: mcRepo repoUrl.
		aRenderer key: 'packages' value: [ 
			aRenderer array: [ 
				mcRepo packageInfos do: [ :each |
					self renderPackageInfo: each on: aRenderer ] ] ] ]
]

{ #category : #rendering }
SPMonticelloRepoJson >> renderItem: anItem on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'id' value: anItem id.
		aRenderer key: 'repoUrl' value: anItem repoUrl ]
]

{ #category : #rendering }
SPMonticelloRepoJson >> renderList: aList more: hasMore on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'list' value: [ 
			aRenderer array: [ 
				aList do: [ :each |
					self renderItem: each on: aRenderer ] ].
		aRenderer key: 'hasMore' value: hasMore ] ]
]

{ #category : #rendering }
SPMonticelloRepoJson >> renderList: aList on: aRenderer [

	aRenderer array: [ 
		aList do: [ :each |
			self renderItem: each on: aRenderer ] ]
]

{ #category : #rendering }
SPMonticelloRepoJson >> renderPackageInfo: mcPackageInfo on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'name' value: mcPackageInfo name.
		aRenderer key: 'count' value: mcPackageInfo count.
		aRenderer key: 'minDatetime' value: mcPackageInfo minDatetime.
		aRenderer key: 'maxDatetime' value: mcPackageInfo maxDatetime.
		aRenderer key: 'authors' value: mcPackageInfo authors sorted ]
]
