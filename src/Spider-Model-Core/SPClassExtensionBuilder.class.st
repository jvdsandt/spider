Class {
	#name : #SPClassExtensionBuilder,
	#superclass : #SPBehaviorBuilder,
	#category : #'Spider-Model-Core-Builders'
}

{ #category : #building }
SPClassExtensionBuilder >> build [

	^ SPGlorpClass extensionName: name
			methodRefs: methodRefs
			comment: nil
]

{ #category : #initialization }
SPClassExtensionBuilder >> setClass: aClass instMethods: instMethods classMethods: classMethods [

	name := aClass name.

	instMethods do: [ :each |
		self addCompiledMethod: each ].
		
	classMethods do: [ :each |
		self addCompiledMethod: each ].
]

{ #category : #initialization }
SPClassExtensionBuilder >> setMCClassname: aClassname methods: aMCMethodDefs [

	name := aClassname.
	
	self privateImportMCMethods: aMCMethodDefs.
	

]

{ #category : #initialization }
SPClassExtensionBuilder >> setTonelFileReference: aFileRef [
	"Initialize this build using a class extension source file in Tonel format."

	| mcDefs className methodDefs |
	
	mcDefs := aFileRef readStreamDo: [ :s | TonelParser parseStream: s ].
	methodDefs := mcDefs select: [ :each | each isMethodDefinition ].
	className := methodDefs first className.
	
	self setMCClassname: className methods: methodDefs

]
