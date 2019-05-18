Class {
	#name : #SpiderDescriptorSystem,
	#superclass : #DescriptorSystem,
	#category : #'Spider-Model-RDB-Glorp'
}

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpClass: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #type type: Integer.	
	aClassModel newAttributeNamed: #name type: Symbol.	
	aClassModel newAttributeNamed: #comment type: String.
	aClassModel newAttributeNamed: #classHash type: ByteArray.	
	aClassModel newAttributeNamed: #classType type: Symbol.	
	aClassModel newAttributeNamed: #superclassName type: Symbol.
	aClassModel newAttributeNamed: #methodRefs collection: Array of: SPGlorpClassToMethodRef.
	aClassModel newAttributeNamed: #variableRefs collection: Array of: SPGlorpClassToVariableRef.
	aClassModel newAttributeNamed: #traitCompositionString type: String.
	aClassModel newAttributeNamed: #classTraitCompositionString type: String.


]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpClassToMethodRef: aClassModel [

	aClassModel newAttributeNamed: #type type: Integer.	
	aClassModel newAttributeNamed: #category type: Symbol.
	aClassModel newAttributeNamed: #method type: SPGlorpMethod.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpClassToVariableRef: aClassModel [

	aClassModel newAttributeNamed: #type type: Integer.	
	aClassModel newAttributeNamed: #variable type: Symbol.
	aClassModel newAttributeNamed: #expression type: String.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpMethod: aClassModel [

	aClassModel
		newAttributeNamed: #id type: Integer;
		newAttributeNamed: #transaction type: SPGlorpTransaction;
		newAttributeNamed: #selector type: Symbol;
		newAttributeNamed: #source type: String;
		newAttributeNamed: #sourceHash type: ByteArray;
		newAttributeNamed: #selectorRefs collection: Array of: SPGlorpMethodToSelectorRef;
		newAttributeNamed: #variableRefs collection: Array of: SPGlorpMethodToVariableRef
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpMethodToSelectorRef: aClassModel [

	aClassModel
		newAttributeNamed: #selector type: Symbol;
		newAttributeNamed: #flags type: Integer
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpMethodToVariableRef: aClassModel [

	aClassModel
		newAttributeNamed: #variable type: Symbol;
		newAttributeNamed: #flags type: Integer
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpMonticelloClassDiff: aClassModel [

	aClassModel newAttributeNamed: #fromPackage type: SPGlorpMonticelloPackage.
	aClassModel newAttributeNamed: #toPackage type: SPGlorpMonticelloPackage.
	aClassModel newAttributeNamed: #oldClass type: SPGlorpClass.
	aClassModel newAttributeNamed: #newClass type: SPGlorpClass.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpMonticelloPackage: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #name type: Symbol.	
	aClassModel newAttributeNamed: #mcId type: ByteArray.
	aClassModel newAttributeNamed: #version type: Integer.	
	aClassModel newAttributeNamed: #branch type: String.
	aClassModel newAttributeNamed: #author type: String.
	aClassModel newAttributeNamed: #datetime type: DateAndTime.
	aClassModel newAttributeNamed: #message type: String.
	aClassModel newAttributeNamed: #package type: SPGlorpPackage.
	aClassModel newAttributeNamed: #ancestors collectionOf: SPGlorpPackage.
	aClassModel newAttributeNamed: #rootId type: Integer.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpMonticelloRepoToPackageRef: aClassModel [

	aClassModel newAttributeNamed: #filename type: String.	
	aClassModel newAttributeNamed: #mcPackage type: SPGlorpMonticelloPackage.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpMonticelloRepository: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #repoUrl type: String.	
	aClassModel newAttributeNamed: #mcPackageRefs collectionOf: SPGlorpMonticelloPackage.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpPackage: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #name type: Symbol.	
	aClassModel newAttributeNamed: #comment type: String.
	aClassModel newAttributeNamed: #packageHash type: ByteArray.	
	aClassModel newAttributeNamed: #classRefs collection: Array of: SPGlorpPackageToClassRef.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpPackageToClassRef: aClassModel [

	aClassModel newAttributeNamed: #spiderClass type: SPGlorpClass.	
	aClassModel newAttributeNamed: #category type: Symbol.
	aClassModel newAttributeNamed: #spiderClassName type: Symbol.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpSelector: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #selector type: Symbol.	

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpSession: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #startedAt type: DateAndTime.	
	aClassModel newAttributeNamed: #imageVersion type: String.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpTransaction: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #session type: SPGlorpSession.	
	aClassModel newAttributeNamed: #startedAt type: DateAndTime.
	aClassModel newAttributeNamed: #message type: String.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpVariable: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #variable type: Symbol.	

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpClass: aDescriptor [

	| table varRefsTable methodRefsTable |
	
	table := self tableNamed: 'CLASSES'.

	varRefsTable := self tableNamed: 'CLASS_VAR_REFS'.
	methodRefsTable := self tableNamed: 'CLASS_MET_REFS'.
	
	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #type to: (table fieldNamed: 'TYPE').
	(aDescriptor newMapping: DirectMapping) 
		from: #name to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping) 
		from: #superclassName to: (table fieldNamed: 'SUPERCLASSNAME').
	(aDescriptor newMapping: DirectMapping) 
		from: #comment to: (table fieldNamed: 'COMMENT').
	(aDescriptor newMapping: DirectMapping) 
		from: #classHash to: (table fieldNamed: 'HASH').
	(aDescriptor newMapping: DirectMapping) 
		from: #classType to: (table fieldNamed: 'CLASS_TYPE').
	(aDescriptor newMapping: DirectMapping) 
		from: #traitCompositionString to: (table fieldNamed: 'INST_TRAIT').
	(aDescriptor newMapping: DirectMapping) 
		from: #classTraitCompositionString to: (table fieldNamed: 'CLASS_TRAIT').
		
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID')).

	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #variableRefs;
		referenceClass: SPGlorpClassToVariableRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (varRefsTable fieldNamed: 'CLASS_ID')).
		
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #methodRefs;
		referenceClass: SPGlorpClassToMethodRef;
		orderBy: [ :e | e method selector ];
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (methodRefsTable fieldNamed: 'CLASS_ID')).
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpClassToMethodRef: aDescriptor [

	| table methodsTable |
	
	table := self tableNamed: 'CLASS_MET_REFS'.
	methodsTable := self tableNamed: 'METHODS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #type to: (table fieldNamed: 'TYPE').
	(aDescriptor newMapping: DirectMapping) 
		from: #category to: (table fieldNamed: 'CATEGORY').
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #method;
		referenceClass: SPGlorpMethod;
		shouldProxy: false;
		join: (Join
			from: (table fieldNamed: 'METHOD_ID')
			to: (methodsTable fieldNamed: 'ID')).

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #class;
		beForPseudoVariable;
		referenceClass: SPGlorpClass;
		join: (Join
			from: (table fieldNamed: 'CLASS_ID')
			to: ((self tableNamed: 'CLASSES') fieldNamed: 'ID')).


]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpClassToVariableRef: aDescriptor [

	| table |
	
	table := self tableNamed: 'CLASS_VAR_REFS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #variable to: (table fieldNamed: 'VARIABLE').
	(aDescriptor newMapping: DirectMapping) 
		from: #type to: (table fieldNamed: 'TYPE').
	(aDescriptor newMapping: DirectMapping) 
		from: #expression to: (table fieldNamed: 'EXPRESSION').
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpMethod: aDescriptor [

	| table varRefsTable msgSendsTable |
	
	table := self tableNamed: 'METHODS'.
	varRefsTable := self tableNamed: 'METHOD_VAR_REFS'.
	msgSendsTable := self tableNamed: 'METHOD_SEL_REFS'.
	
	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #selector to: (table fieldNamed: 'SELECTOR').
	(aDescriptor newMapping: DirectMapping) 
		from: #source to: (table fieldNamed: 'SOURCE').
	(aDescriptor newMapping: DirectMapping) 
		from: #sourceHash to: (table fieldNamed: 'HASH').
		
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID')).

	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #variableRefs;
		referenceClass: SPGlorpMethodToVariableRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (varRefsTable fieldNamed: 'METHOD_ID')).
		
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #selectorRefs;
		referenceClass: SPGlorpMethodToSelectorRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (msgSendsTable fieldNamed: 'METHOD_ID')).
			
		
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #classToMethodRefs;
		beForPseudoVariable;
		referenceClass: SPGlorpClassToMethodRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: ((self tableNamed: 'CLASS_MET_REFS') fieldNamed: 'METHOD_ID')).
"	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #classes;
		beForPseudoVariable;
		referenceClass: SPGlorpClass;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: ((self tableNamed: 'CLASS_MET_REFS') fieldNamed: 'METHOD_ID')).
"
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpMethodToSelectorRef: aDescriptor [

	| table |
	
	table := self tableNamed: 'METHOD_SEL_REFS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #selector to: (table fieldNamed: 'SELECTOR').
	(aDescriptor newMapping: DirectMapping) 
		from: #flags to: (table fieldNamed: 'FLAGS').
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpMethodToVariableRef: aDescriptor [

	| table |
	
	table := self tableNamed: 'METHOD_VAR_REFS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #variable to: (table fieldNamed: 'VARIABLE').
	(aDescriptor newMapping: DirectMapping) 
		from: #flags to: (table fieldNamed: 'FLAGS').
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpMonticelloClassDiff: aDescriptor [

	| table |
	
	table := self tableNamed: 'MC_CLASS_DIFFS'.
	aDescriptor table: table.
	
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #fromPackage;
		join: (Join
			from: (table fieldNamed: 'FROM_PACKAGE_ID')
			to: ((self tableNamed: 'MC_PACKAGES') fieldNamed: 'ID')).
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #toPackage;
		join: (Join
			from: (table fieldNamed: 'TO_PACKAGE_ID')
			to: ((self tableNamed: 'MC_PACKAGES') fieldNamed: 'ID')).
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #oldClass;
		join: (Join
			from: (table fieldNamed: 'OLD_CLASS_ID')
			to: ((self tableNamed: 'CLASSES') fieldNamed: 'ID')).
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #newClass;
		join: (Join
			from: (table fieldNamed: 'NEW_CLASS_ID')
			to: ((self tableNamed: 'CLASSES') fieldNamed: 'ID')).

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpMonticelloPackage: aDescriptor [

	| table packageTable ancestorsRefsTable |
	
	table := self tableNamed: 'MC_PACKAGES'.
	packageTable := self tableNamed: 'PACKAGES'.
	ancestorsRefsTable := self tableNamed: 'MC_PACKAGE_ANCESTORS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #name to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping) 
		from: #mcId to: (table fieldNamed: 'MC_ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #datetime to: (table fieldNamed: 'DATETIME').
	(aDescriptor newMapping: DirectMapping) 
		from: #author to: (table fieldNamed: 'AUTHOR').
	(aDescriptor newMapping: DirectMapping) 
		from: #version to: (table fieldNamed: 'VERSION').
	(aDescriptor newMapping: DirectMapping) 
		from: #message to: (table fieldNamed: 'MESSAGE').
	(aDescriptor newMapping: DirectMapping) 
		from: #branch to: (table fieldNamed: 'BRANCH').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID')).

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #package;
		join: (Join
			from: (table fieldNamed: 'PACKAGE_ID')
			to: (packageTable fieldNamed: 'ID')).

	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #ancestors;
		referenceClass: SPGlorpMonticelloPackage;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (ancestorsRefsTable fieldNamed: 'MC_PACKAGE_ID')).
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpMonticelloRepoToPackageRef: aDescriptor [

	| table mcPackageTable |
	
	table := self tableNamed: 'MC_REPO_PACK_REFS'.
	mcPackageTable := self tableNamed: 'MC_PACKAGES'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #filename to: (table fieldNamed: 'FILENAME').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #mcPackage;
		join: (Join
			from: (table fieldNamed: 'MC_PACKAGE_ID')
			to: (mcPackageTable fieldNamed: 'ID')).
			
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #repository;
		beForPseudoVariable;
		referenceClass: SPGlorpMonticelloRepository;
		join: (Join
			from: (table fieldNamed: 'MC_REPO_ID')
			to: ((self tableNamed: 'MC_REPOS') fieldNamed: 'ID')).


]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpMonticelloRepository: aDescriptor [

	| table packageRefsTable |
	
	table := self tableNamed: 'MC_REPOS'.
	packageRefsTable := self tableNamed: 'MC_REPO_PACK_REFS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #repoUrl to: (table fieldNamed: 'REPO_URL').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID')).

	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #mcPackageRefs;
		referenceClass: SPGlorpMonticelloRepoToPackageRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (packageRefsTable fieldNamed: 'MC_REPO_ID')).

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpPackage: aDescriptor [

	| table classRefsTable |
	
	table := self tableNamed: 'PACKAGES'.
	classRefsTable := self tableNamed: 'PACKAGE_CLS_REFS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #name to: (table fieldNamed: 'NAME').
	(aDescriptor newMapping: DirectMapping) 
		from: #packageHash to: (table fieldNamed: 'HASH').
	(aDescriptor newMapping: DirectMapping) 
		from: #comment to: (table fieldNamed: 'COMMENT').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID')).

	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #classRefs;
		referenceClass: SPGlorpPackageToClassRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (classRefsTable fieldNamed: 'PACKAGE_ID')).

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpPackageToClassRef: aDescriptor [

	| table classesTable |
	
	table := self tableNamed: 'PACKAGE_CLS_REFS'.
	classesTable := self tableNamed: 'CLASSES'.

	aDescriptor table: table.
	aDescriptor addTable: classesTable.
	aDescriptor addMultipleTableJoin: (
		Join 
			from: (table fieldNamed: 'CLASS_ID')
			to: (classesTable fieldNamed: 'ID')).
		
	(aDescriptor newMapping: DirectMapping) 
		from: #category to: (table fieldNamed: 'CATEGORY').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #spiderClass;
		referenceClass: SPGlorpClass;
		join: (Join
			from: (table fieldNamed: 'CLASS_ID')
			to: (classesTable fieldNamed: 'ID')).

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpSelector: aDescriptor [

	| table |
	
	table := self tableNamed: 'SELECTORS'.
	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #selector to: (table fieldNamed: 'SELECTOR').
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID'))

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpSession: aDescriptor [

	| table |
	
	table := self tableNamed: 'SP_SESSIONS'.
	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #startedAt to: (table fieldNamed: 'STARTED_AT').
	(aDescriptor newMapping: DirectMapping) 
		from: #imageVersion to: (table fieldNamed: 'IMAGE_VERSION').
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpTransaction: aDescriptor [

	| table |
	
	table := self tableNamed: 'SP_TRANSACTIONS'.
	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #startedAt to: (table fieldNamed: 'STARTED_AT').
	(aDescriptor newMapping: DirectMapping) 
		from: #message to: (table fieldNamed: 'MESSAGE').
		
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #session;
		join: (Join
			from: (table fieldNamed: 'SP_SESSION_ID')
			to: ((self tableNamed: 'SP_SESSIONS') fieldNamed: 'ID')).

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpVariable: aDescriptor [

	| table |
	
	table := self tableNamed: 'VARIABLES'.
	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #variable to: (table fieldNamed: 'VARIABLE').
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		referenceClass: SPGlorpTransaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID'))

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForCLASSES: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'TYPE' type: platform integer.
	aTable createFieldNamed: 'NAME' type: platform varchar.
	aTable createFieldNamed: 'HASH' type: platform blob.
	aTable createFieldNamed: 'CLASS_TYPE' type: platform varchar.
	aTable createFieldNamed: 'SUPERCLASSNAME' type: platform varchar.
	aTable createFieldNamed: 'INST_TRAIT' type: platform varchar.
	aTable createFieldNamed: 'CLASS_TRAIT' type: platform varchar.
	aTable createFieldNamed: 'COMMENT' type: platform varchar.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForCLASS_MET_REFS: aTable [

	| classIdField methodIdField |

	classIdField := (aTable createFieldNamed: 'CLASS_ID' type: (platform serial)) bePrimaryKey.
	(aTable createFieldNamed: 'TYPE' type: platform integer) bePrimaryKey.
	methodIdField := (aTable createFieldNamed: 'METHOD_ID' type: platform integer) bePrimaryKey.
	aTable createFieldNamed: 'CATEGORY' type: platform text.

	aTable addForeignKeyFrom: classIdField to: ((self tableNamed: 'CLASSES') fieldNamed: 'ID').
	aTable addForeignKeyFrom: methodIdField to: ((self tableNamed: 'METHODS') fieldNamed: 'ID').

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForCLASS_VAR_REFS: aTable [

	(aTable createFieldNamed: 'CLASS_ID' type: (platform serial)) bePrimaryKey.
	(aTable createFieldNamed: 'TYPE' type: platform integer) bePrimaryKey.
	(aTable createFieldNamed: 'VARIABLE' type: platform varchar) bePrimaryKey.
	aTable createFieldNamed: 'EXPRESSION' type: platform text.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForMC_CLASS_DIFFS: aTable [

	(aTable createFieldNamed: 'FROM_PACKAGE_ID' type: platform integer) bePrimaryKey.
	(aTable createFieldNamed: 'TO_PACKAGE_ID' type: platform integer) bePrimaryKey.
	(aTable createFieldNamed: 'OLD_CLASS_ID' type: platform integer) bePrimaryKey.
	(aTable createFieldNamed: 'NEW_CLASS_ID' type: platform integer) bePrimaryKey.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForMC_PACKAGES: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'ROOT_ID' type: platform integer.
	aTable createFieldNamed: 'NAME' type: platform text.
	aTable createFieldNamed: 'MC_ID' type: platform blob.
	aTable createFieldNamed: 'DATETIME' type: platform timestamp.
	aTable createFieldNamed: 'AUTHOR' type: platform varchar.
	aTable createFieldNamed: 'VERSION' type: platform integer.
	aTable createFieldNamed: 'MESSAGE' type: platform text.
	aTable createFieldNamed: 'BRANCH' type: platform varchar.
	aTable createFieldNamed: 'PACKAGE_ID' type: platform integer.


]

{ #category : #tables }
SpiderDescriptorSystem >> tableForMC_PACKAGE_ANCESTORS: aTable [

	| packIdField ancestorIdField |

	packIdField := (aTable createFieldNamed: 'MC_PACKAGE_ID' type: platform integer) bePrimaryKey.
	ancestorIdField := (aTable createFieldNamed: 'MC_ANCESTOR_ID' type: platform integer) bePrimaryKey.
	
	aTable addForeignKeyFrom: packIdField to: ((self tableNamed: 'MC_PACKAGES') fieldNamed: 'ID').
	aTable addForeignKeyFrom: ancestorIdField to: ((self tableNamed: 'MC_PACKAGES') fieldNamed: 'ID').
	
	

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForMC_REPOS: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'REPO_URL' type: platform varchar.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForMC_REPO_PACK_REFS: aTable [

	(aTable createFieldNamed: 'MC_REPO_ID' type: (platform serial)) bePrimaryKey.
	(aTable createFieldNamed: 'MC_PACKAGE_ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'FILENAME' type: platform varchar.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForMETHODS: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'SELECTOR' type: platform varchar.
	aTable createFieldNamed: 'HASH' type: platform blob.
	aTable createFieldNamed: 'SOURCE' type: platform varchar.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForMETHOD_SEL_REFS: aTable [

	(aTable createFieldNamed: 'METHOD_ID' type: (platform integer)) bePrimaryKey.
	(aTable createFieldNamed: 'SELECTOR' type: (platform varchar)) bePrimaryKey.
	aTable createFieldNamed: 'FLAGS' type: platform integer.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForMETHOD_VAR_REFS: aTable [

	(aTable createFieldNamed: 'METHOD_ID' type: (platform integer)) bePrimaryKey.
	(aTable createFieldNamed: 'VARIABLE' type: (platform varchar)) bePrimaryKey.
	aTable createFieldNamed: 'FLAGS' type: platform integer.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForPACKAGES: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'NAME' type: platform text.
	aTable createFieldNamed: 'HASH' type: platform blob.
	aTable createFieldNamed: 'COMMENT' type: platform varchar.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForPACKAGE_CLS_REFS: aTable [

	(aTable createFieldNamed: 'PACKAGE_ID' type: (platform integer)) bePrimaryKey.
	(aTable createFieldNamed: 'CLASS_ID' type: (platform integer)) bePrimaryKey.
	aTable createFieldNamed: 'CATEGORY' type: platform text.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForSELECTORS: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'SELECTOR' type: platform varchar.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForSP_SESSIONS: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'STARTED_AT' type: platform dateAndTime.
	aTable createFieldNamed: 'IMAGE_VERSION' type: platform varchar.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForSP_TRANSACTIONS: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'SP_SESSION_ID' type: platform integer. 
	aTable createFieldNamed: 'STARTED_AT' type: platform dateAndTime.
	aTable createFieldNamed: 'MESSAGE' type: platform text.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForVARIABLES: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'VARIABLE' type: platform varchar.

]