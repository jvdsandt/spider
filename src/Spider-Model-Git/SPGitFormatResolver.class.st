Class {
	#name : #SPGitFormatResolver,
	#superclass : #Object,
	#instVars : [
		'fileReference',
		'sourceDirectory',
		'format',
		'packagesPresent'
	],
	#category : #'Spider-Model-Git-Builders'
}

{ #category : #'instance creation' }
SPGitFormatResolver class >> on: aFileReference [

	^ self new
			fileReference: aFileReference;
			yourself
]

{ #category : #'instance creation' }
SPGitFormatResolver class >> onGitCommit: aCommit [

	^ self on: (FileSystem onGitCommit: aCommit) root
]

{ #category : #internal }
SPGitFormatResolver >> checkFileTreePackagesPresentIn: aDirectory [

	^ aDirectory exists and: [
		(aDirectory directoriesMatching: '*.package')
			anySatisfy: [ :each | (each / '.filetree') exists ] ]
]

{ #category : #resolving }
SPGitFormatResolver >> checkPackagesPresent [

	self sourceDirectory isNil
		ifTrue: [ ^ packagesPresent := false ].

	self isTonelFormat 
		ifTrue: [ ^ packagesPresent := self checkTonelPackagesPresentIn: self sourceReference ].
	self isFileTreeFormat 
		ifTrue: [ ^ packagesPresent := self checkFileTreePackagesPresentIn: self sourceReference ].
		
	^ packagesPresent := false
]

{ #category : #internal }
SPGitFormatResolver >> checkTonelPackagesPresentIn: aDirectory [

	^ aDirectory exists and: [ 
			aDirectory directories anySatisfy: [ :each | (each / 'package.st') exists ] ]
]

{ #category : #accessing }
SPGitFormatResolver >> codeReader [

	self isTonelFormat 
		ifTrue: [ ^ SPTonelCodeReader on: self sourceReference ].
		
	self isFileTreeFormat 
		ifTrue: [ ^ SPFileTreeCodeReader on: self sourceReference ].
		
	self error: 'Unknown format'
]

{ #category : #accessing }
SPGitFormatResolver >> fileReference [
	^ fileReference
]

{ #category : #accessing }
SPGitFormatResolver >> fileReference: anObject [
	fileReference := anObject
]

{ #category : #accessing }
SPGitFormatResolver >> format [
	^ format
]

{ #category : #testing }
SPGitFormatResolver >> isFileTreeFormat [

	^ format = #filetree
]

{ #category : #testing }
SPGitFormatResolver >> isTonelFormat [

	^ format = #tonel
]

{ #category : #accessing }
SPGitFormatResolver >> packagesPresent [
	^ packagesPresent
]

{ #category : #resolving }
SPGitFormatResolver >> resolve [

	| possibleDirs |
	
	self resolveSourceDirectory.
	self resolveFormat.
	self checkPackagesPresent
		ifTrue: [ ^ true ].
	
	possibleDirs := #( '' 'src' 'source' 'repo' 'repository' ).
	(sourceDirectory notNil and: [ (possibleDirs contains: sourceDirectory) not ])
		ifTrue: [ possibleDirs := (Array with: sourceDirectory), possibleDirs ].
		
	possibleDirs do: [ :each |
		(self tryFileTreeIn: fileReference / each)
			ifTrue: [ ^ true ].
		(self tryTonelIn: fileReference / each)
			ifTrue: [ ^ true ] ].
		
	^ false
]

{ #category : #resolving }
SPGitFormatResolver >> resolveFormat [

	| propsFile propsData |
	
	propsFile := fileReference / '.properties'.
	propsFile exists
		ifFalse: [ ^ self ].
		
	propsData := self stonParse: propsFile.
	format := propsData at: #format ifAbsent: [ nil ].
]

{ #category : #resolving }
SPGitFormatResolver >> resolveSourceDirectory [

	| projectFile projectJson |
	
	projectFile := fileReference / '.project'.
	projectFile exists
		ifFalse: [ ^ self ].
		
	projectJson := self stonParse: projectFile.
	projectJson isNil
		ifTrue: [ ^ self ].
		
	sourceDirectory := projectJson at: 'srcDirectory' ifAbsent: [ nil ].
	(fileReference / sourceDirectory) exists
		ifFalse: [ sourceDirectory := nil ]
]

{ #category : #accessing }
SPGitFormatResolver >> sourceDirectory [
	^ sourceDirectory
]

{ #category : #accessing }
SPGitFormatResolver >> sourceReference [

	^ self fileReference / sourceDirectory
]

{ #category : #internal }
SPGitFormatResolver >> stonParse: aFileRef [

	^ [ aFileRef readStreamDo: [:s | STON fromStream: s ] ] on: Error do: [ nil ]
]

{ #category : #internal }
SPGitFormatResolver >> tryFileTreeIn: aDirectory [

	(self checkFileTreePackagesPresentIn: aDirectory) 
		ifTrue: [ 
			format := #filetree.
			sourceDirectory := aDirectory pathString.
			^ packagesPresent := true ].
	^ false
]

{ #category : #internal }
SPGitFormatResolver >> tryTonelIn: aDirectory [

	(self checkTonelPackagesPresentIn: aDirectory) 
		ifTrue: [ 
			format := #tonel.
			sourceDirectory := aDirectory pathString.
			^ packagesPresent := true ].
	^ false
]
