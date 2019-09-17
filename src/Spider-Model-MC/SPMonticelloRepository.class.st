Class {
	#name : #SPMonticelloRepository,
	#superclass : #SPGlorpNode,
	#instVars : [
		'repoUrl',
		'mcPackageRefs'
	],
	#category : #'Spider-Model-MC-Domains'
}

{ #category : #'instance creation' }
SPMonticelloRepository class >> repoUrl: anUrl packages: aMcPackageRefs [

	^ self new initWithRepoUrl: anUrl packages: aMcPackageRefs
]

{ #category : #initialization }
SPMonticelloRepository >> initWithRepoUrl: anUrl packages: aMcPackageRefs [

	repoUrl := anUrl.
	mcPackageRefs := aMcPackageRefs
]

{ #category : #accessing }
SPMonticelloRepository >> mcPackageRefs [
	^ mcPackageRefs
]

{ #category : #accessing }
SPMonticelloRepository >> packageInfos [

	| infoDict |
	
	infoDict := self mcPackageRefs 
		inject: Dictionary new
		into: [ :dict :each |
			| mcPackage |
			mcPackage := each mcPackage.
			(dict at: mcPackage name ifAbsentPut: [ SPMonticelloPackageInfo named: mcPackage name ])
				process: mcPackage.
			dict ].
	^ infoDict values sorted
]

{ #category : #accessing }
SPMonticelloRepository >> repoUrl [
	^ repoUrl
]
