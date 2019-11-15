Class {
	#name : #SPGitRepoJson,
	#superclass : #SPJsonComponent,
	#category : #'Spider-Web-API'
}

{ #category : #rendering }
SPGitRepoJson >> renderBranchesOf: aGitRepo on: aRenderer [

	aRenderer key: 'branches' value: [ 
		aRenderer array: [ 
			(aGitRepo mostRecentBranches: 25) do: [ :each |
				aRenderer object: [ 
					aRenderer key: 'name' value: each name.
					aRenderer key: 'sha' value: each shaString.
					aRenderer key: 'datetime' value: each datetime ] ] ] ]
]

{ #category : #rendering }
SPGitRepoJson >> renderItem: anItem on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'id' value: anItem id.
		aRenderer key: 'name' value: anItem name.
		aRenderer key: 'owner' value: anItem owner.
		aRenderer key: 'domain' value: anItem domain.
		aRenderer key: 'url' value: anItem url ]
]

{ #category : #rendering }
SPGitRepoJson >> renderList: aList more: hasMore on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'list' value: [ 
			aRenderer array: [ 
				aList do: [ :each |
					self renderItem: each on: aRenderer ] ].
		aRenderer key: 'hasMore' value: hasMore ] ]
]

{ #category : #rendering }
SPGitRepoJson >> renderList: aList on: aRenderer [

	aRenderer array: [ 
		aList do: [ :each |
			self renderItem: each on: aRenderer ] ]
]

{ #category : #rendering }
SPGitRepoJson >> renderRepo: anItem on: aRenderer [

	aRenderer object: [ 
		aRenderer key: 'id' value: anItem id.
		aRenderer key: 'name' value: anItem name.
		aRenderer key: 'owner' value: anItem owner.
		aRenderer key: 'domain' value: anItem domain.
		aRenderer key: 'url' value: anItem url.
		self renderBranchesOf: anItem on: aRenderer.
		self renderTagsOf: anItem on: aRenderer ]
]

{ #category : #rendering }
SPGitRepoJson >> renderTagsOf: aGitRepo on: aRenderer [

	aRenderer key: 'tags' value: [ 
		aRenderer array: [ 
			(aGitRepo mostRecentTags: 25) do: [ :each |
				aRenderer object: [ 
					aRenderer key: 'name' value: each name.
					aRenderer key: 'sha' value: each shaString.
					aRenderer key: 'datetime' value: each datetime ] ] ] ]
]
