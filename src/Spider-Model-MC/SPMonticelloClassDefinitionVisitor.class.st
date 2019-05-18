Class {
	#name : #SPMonticelloClassDefinitionVisitor,
	#superclass : #Object,
	#instVars : [
		'builder',
		'methodsByClass'
	],
	#category : #'Spider-Model-MC-Builders'
}

{ #category : #'instance creation' }
SPMonticelloClassDefinitionVisitor class >> builder: aPackageBuilder methods: aMethodsByClass [

	^ self new initBuilder: aPackageBuilder methods: aMethodsByClass
]

{ #category : #initialization }
SPMonticelloClassDefinitionVisitor >> initBuilder: aPackageBuilder methods: aMethodsByClass [

	builder := aPackageBuilder.
	methodsByClass := aMethodsByClass
]

{ #category : #visiting }
SPMonticelloClassDefinitionVisitor >> visitClassDefinition: aClassDefinition [
	"Add this MCDefinition as a SPClass"

	builder addMCClass: aClassDefinition 
		methods: (methodsByClass removeKey: aClassDefinition className ifAbsent: [ #() ])
]

{ #category : #visiting }
SPMonticelloClassDefinitionVisitor >> visitClassTraitDefinition: aClassTraitDefinition [
	"ignore"
]

{ #category : #visiting }
SPMonticelloClassDefinitionVisitor >> visitMetaclassDefinition: aDefinition [
	"not interesting for us"

]

{ #category : #visiting }
SPMonticelloClassDefinitionVisitor >> visitTraitDefinition: aTraitDefinition [
	"Add this MCDefinition as a Trait node"

	builder addMCTrait: aTraitDefinition 
			methods: (methodsByClass removeKey: aTraitDefinition className ifAbsent: [ #() ])
]
