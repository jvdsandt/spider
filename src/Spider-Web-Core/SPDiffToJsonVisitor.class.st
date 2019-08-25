Class {
	#name : #SPDiffToJsonVisitor,
	#superclass : #SPDiffVisitor,
	#instVars : [
		'renderer',
		'maxSourceSize'
	],
	#category : #'Spider-Web-Core-API'
}

{ #category : #accessing }
SPDiffToJsonVisitor >> maxSourceSize [
	^ maxSourceSize ifNil: [ maxSourceSize := 10 * 1024 ]
]

{ #category : #accessing }
SPDiffToJsonVisitor >> maxSourceSize: anObject [
	maxSourceSize := anObject
]

{ #category : #accessing }
SPDiffToJsonVisitor >> renderer [
	^ renderer
]

{ #category : #accessing }
SPDiffToJsonVisitor >> renderer: anObject [
	renderer := anObject
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitAll: aDiffs [

	renderer array: [ 
		aDiffs do: [ :each | self visit: each ] ]
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffAddedClass: aDiff [

	renderer object: [ 
		renderer key: 'newClass' value: [ 
			renderer object: [ 
				SPClassJson new
					renderClassSummary: aDiff newClass in: aDiff newObject category on: renderer ] ] ]
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffAddedMethod: aDiff [

	renderer object: [ 
		renderer key: 'newMethod' value: [ 
			renderer object: [ 
				SPMethodJson new
					renderMethodSummary: aDiff newMethod in: aDiff newCategory on: renderer ] ] ]
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffAddedPackage: aDiff [

	renderer object: [ 
		renderer key: 'newPackage' value: [ 
			SPPackageJson new
				renderPackageSummary: aDiff newObject on: renderer ] ]
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffRemovedClass: aDiff [

	renderer object: [ 
		renderer key: 'oldClass' value: [ 
			renderer object: [ 
				SPClassJson new
					renderClassSummary: aDiff oldClass in: aDiff oldObject category on: renderer ] ] ]
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffRemovedMethod: aDiff [

	renderer object: [ 
		renderer key: 'oldMethod' value: [ 
			renderer object: [ 
				SPMethodJson new
					renderMethodSummary: aDiff oldObject on: renderer ] ] ]
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffRemovedPackage: aDiff [

	renderer object: [ 
		renderer key: 'oldPackage' value: [ 
			SPPackageJson new
				renderPackageSummary: aDiff oldObject on: renderer ] ]
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffUpdatedClass: aDiff [

	renderer object: [ 
		renderer key: 'oldClass' value: [ 
			renderer object: [ 
				SPClassJson new
					renderClassSummary: aDiff oldSpiderClass in: aDiff oldObject category on: renderer ] ].
		renderer key: 'newClass' value: [ 
			renderer object: [ 
				SPClassJson new
					renderClassSummary: aDiff newSpiderClass in: aDiff newObject category on: renderer ] ].
			
		renderer key: 'methodDiffs' value: [ 
			renderer array: [ 
				aDiff methodDiffs do: [ :each |
					self visit: each ] ] ].
		
		aDiff hasCommentDiff
			ifTrue: [ 
				renderer key: 'commentDiff' value: [ 
					renderer object: [ 
						renderer key: 'oldComment' value: aDiff oldSpiderClass comment.
						renderer key: 'newComment' value: aDiff newSpiderClass comment ] ] ] ]
				
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffUpdatedMethod: aDiff [

	renderer object: [ 
		renderer key: 'oldMethod' value: [ 
			SPMethodJson new
				renderMethodSummary: aDiff oldMethod in: aDiff oldCategory on: renderer ].
		renderer key: 'newMethod' value: [ 
			SPMethodJson new
				renderMethodSummary: aDiff newMethod in: aDiff newCategory on: renderer ] ]
]

{ #category : #visiting }
SPDiffToJsonVisitor >> visitDiffUpdatedPackage: aDiff [

	renderer object: [ 
		renderer key: 'oldPackage' value: [ 
			renderer object: [ 
				SPPackageJson new
					renderPackageSummary: aDiff oldObject on: renderer ] ].
		renderer key: 'newPackage' value: [ 
			renderer object: [ 
				SPPackageJson new
					renderPackageSummary: aDiff newObject on: renderer ] ].
			
		renderer key: 'classDiffs' value: [ 
			renderer array: [ 
				aDiff classDiffs do: [ :each |
					self visit: each ] ] ] ]
]
