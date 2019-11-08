Class {
	#name : #SPJsonComponent,
	#superclass : #Object,
	#category : #'Spider-Web-Core'
}

{ #category : #accessing }
SPJsonComponent >> context [
	^ self webContext context
]

{ #category : #accessing }
SPJsonComponent >> diffRepo [ 

	^ self context diffRepo
]

{ #category : #accessing }
SPJsonComponent >> gitRepo [ 

	^ self context gitRepo
]

{ #category : #rendering }
SPJsonComponent >> renderGitCommitSummary: aCommit on: aRenderer [

	SPGitCommitJson new
		renderCommitSummary: aCommit on: aRenderer
]

{ #category : #rendering }
SPJsonComponent >> renderMCPackageSummary: mcPackage on: aRenderer [

	aRenderer 
		key: 'id' value: mcPackage id;
		key: 'name' value: mcPackage name;
		key: 'uuid' value: mcPackage uuid asString;
		key: 'version' value: mcPackage version;
		key: 'author' value: mcPackage author;
		key: 'datetime' value: mcPackage datetime;
		key: 'message' value: mcPackage message
]

{ #category : #accessing }
SPJsonComponent >> webContext [
	^ SPWebContext default
	
]
