Class {
	#name : #SPPackageBuilder,
	#superclass : #Object,
	#instVars : [
		'repo',
		'name',
		'classes',
		'comment'
	],
	#category : #'Spider-Model-Core-Builders'
}

{ #category : #adding }
SPPackageBuilder >> addClass: aSpiderClass category: aCategory [

	| subCategory |
	
	(self isNameUnique: aSpiderClass name)
		ifFalse: [ self error: 'Classname not unique in package' ].
	
	subCategory := aCategory notNil 
		ifTrue: [ 
			aCategory = self name
				ifTrue: [ nil ]
				ifFalse: [ 
					(aCategory beginsWith: self name, '-')
						ifTrue: [ aCategory allButFirst: self name size + 1 ]
						ifFalse: [ aCategory ] ] ]
		ifFalse: [ aCategory ].
	
	subCategory notNil
		ifTrue: [ 
			subCategory := subCategory trimBoth.
			subCategory isEmpty
				ifTrue: [ subCategory := nil ] ].

	^ classes add: (SPPackageToClassRef spiderClass: aSpiderClass category: subCategory)
]

{ #category : #adding }
SPPackageBuilder >> addClassExtension: aSpiderClassExtension [

	(self isNameUnique: aSpiderClassExtension name)
		ifFalse: [ self error: 'Class extension name not unique in package' ].

	^ classes add: (SPPackageToClassRef spiderClass: aSpiderClassExtension)
]

{ #category : #building }
SPPackageBuilder >> build [

	| newPackage existingPackage hash |

	newPackage := SPPackage name: name classRefs: classes comment: comment.
	hash := newPackage packageHash.
	
	existingPackage := self repo getPackageByHash: hash ifAbsent: [ nil ].
	existingPackage notNil
		ifTrue: [ ^ existingPackage ].
		
	^ newPackage
]

{ #category : #accessing }
SPPackageBuilder >> classRepo [

	^ repo classRepo
]

{ #category : #accessing }
SPPackageBuilder >> comment [
	^ comment
]

{ #category : #initialization }
SPPackageBuilder >> initialize [

	super initialize.
	
	classes := OrderedCollection new.
]

{ #category : #testing }
SPPackageBuilder >> isNameUnique: aString [

	^ classes noneSatisfy: [ :eachRef | eachRef name = aString ]
	
]

{ #category : #accessing }
SPPackageBuilder >> name [
	^ name
]

{ #category : #accessing }
SPPackageBuilder >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SPPackageBuilder >> repo [
	^ repo ifNil: [ repo := SPiderImageContext new packageRepo ]
]

{ #category : #initialization }
SPPackageBuilder >> setComment: aString [

	comment := aString
]

{ #category : #initialization }
SPPackageBuilder >> setRPackage: rPackage [

	name := rPackage name.
	
	rPackage definedClasses do: [ :each |
		| spiderClass |
		spiderClass := self classRepo newClassBuilder 
			setClass: each 	instMethods: (rPackage definedMethodsForClass: each) classMethods: (rPackage definedMethodsForClass: each class);
			build.
		self addClass: spiderClass category: (rPackage classTagForClass: each) categoryName ].
	
	rPackage extendedClasses do: [ :each |
		| spiderClassExt |
		spiderClassExt := self classRepo newClassExtensionBuilder 
			setClass: each 	instMethods: (rPackage extensionMethodsForClass: each) classMethods: (rPackage extensionMethodsForClass: each class);
			build.
		self addClassExtension: spiderClassExt ]
]

{ #category : #initialization }
SPPackageBuilder >> setRepo: aPackageRepository [

	repo := aPackageRepository
]
