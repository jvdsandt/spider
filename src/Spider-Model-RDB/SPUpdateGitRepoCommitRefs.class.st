Class {
	#name : #SPUpdateGitRepoCommitRefs,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-RDB-Batch'
}

{ #category : #executing }
SPUpdateGitRepoCommitRefs >> executeForAllRepos [

	| repos |
	
	repos := self glorpSession read: SPGitRepo.
	repos do: [ :each | self executeForRepo: each ]
]

{ #category : #executing }
SPUpdateGitRepoCommitRefs >> executeForRepo: aRepo [

	self context 
		doTransaction: self class name, ' - ', aRepo url
		with: [ self executeForRepo: aRepo txid: self context currentTransactionId ]
]

{ #category : #executing }
SPUpdateGitRepoCommitRefs >> executeForRepo: aRepo txid: txid [

	| statement result existingIds newIds idsToDelete idsToInsert |
	
	statement := self p3client format: 'SELECT commit_id FROM git_repo_commits WHERE repo_id = $1'.
	result := statement query: (Array with: aRepo id).
	existingIds := result data collect: [ :eachRow | eachRow first ].
	
	newIds := Set new.
	aRepo commitRefs do: [ :each | each commit addIdsTo: newIds ].
	
	idsToDelete := existingIds copyWithoutAll: newIds.
	idsToInsert := newIds copyWithoutAll: existingIds.
	
	idsToDelete notEmpty
		ifTrue: [ 
			statement := self p3prepare: 'DELETE FROM git_repo_commits WHERE repo_id = $1 AND commit_id = $2'.
			statement executeBatch: (idsToDelete collect: [ :each |
				Array with: aRepo id with: each ] ) ].
	
	idsToInsert notEmpty
		ifTrue: [ 
			statement := self p3prepare: 'INSERT INTO git_repo_commits (repo_id, commit_id, txid) VALUES ($1,$2,$3)'.
			statement executeBatch: (idsToInsert collect: [ :each |
				Array with: aRepo id with: each with: txid ]) ].
				
	self logInfo: ('Git repo {1} - inserted: {2} deleted: {3} total: {4}' format: (Array 
		with: aRepo url 
		with: idsToInsert size 
		with: idsToDelete size
		with: newIds size))

]
