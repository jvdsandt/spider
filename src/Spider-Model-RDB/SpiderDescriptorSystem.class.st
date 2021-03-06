Class {
	#name : #SpiderDescriptorSystem,
	#superclass : #DescriptorSystem,
	#category : #'Spider-Model-RDB-Glorp'
}

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPClassToMethodRef: aClassModel [

	aClassModel newAttributeNamed: #type type: Integer.	
	aClassModel newAttributeNamed: #category type: Symbol.
	aClassModel newAttributeNamed: #method type: SPMethod.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPClassToVariableRef: aClassModel [

	aClassModel newAttributeNamed: #type type: Integer.	
	aClassModel newAttributeNamed: #variable type: Symbol.
	aClassModel newAttributeNamed: #expression type: String.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGitClassDiffRecord: aClassModel [

	aClassModel newAttributeNamed: #commit type: SPGitCommit.
	aClassModel newAttributeNamed: #newClass type: SPGlorpClass.
	aClassModel newAttributeNamed: #oldClass type: SPGlorpClass.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGitCommit: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #sha type: ByteArray.
	aClassModel newAttributeNamed: #authorSignature type: SPGitSignature.
	aClassModel newAttributeNamed: #message type: String.
	aClassModel newAttributeNamed: #parents collectionOf: SPGitCommit.
	aClassModel newAttributeNamed: #packages collectionOf: SPPackage.
	aClassModel newAttributeNamed: #status type: Symbol.
	aClassModel newAttributeNamed: #rootId type: Integer.
	aClassModel newAttributeNamed: #sourceDir type: String.
	aClassModel newAttributeNamed: #format type: Symbol.
	





]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGitMethodDiffRecord: aClassModel [

	aClassModel newAttributeNamed: #commit type: SPGitCommit.
	aClassModel newAttributeNamed: #isMeta type: Boolean.
	aClassModel newAttributeNamed: #className type: Symbol.
	aClassModel newAttributeNamed: #newMethod type: SPMethod.
	aClassModel newAttributeNamed: #oldMethod type: SPMethod.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGitPackageDiffRecord: aClassModel [

	aClassModel newAttributeNamed: #commit type: SPGitCommit.
	aClassModel newAttributeNamed: #newPackage type: SPPackage.
	aClassModel newAttributeNamed: #oldPackage type: SPPackage.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGitRepo: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #url type: String.
	aClassModel newAttributeNamed: #commitRefs collectionOf: SPGitRepoToCommitRef.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGitRepoToCommitRef: aClassModel [

	aClassModel newAttributeNamed: #name type: String.
	aClassModel newAttributeNamed: #type type: String.
	aClassModel newAttributeNamed: #commit type: SPGitCommit.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGitSignature: aClassModel [

	aClassModel newAttributeNamed: #name type: String.
	aClassModel newAttributeNamed: #email type: String.
	aClassModel newAttributeNamed: #datetime type: DateAndTime.
	aClassModel newAttributeNamed: #tzOffset type: Integer.

]

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
	aClassModel newAttributeNamed: #methodRefs collection: Array of: SPClassToMethodRef.
	aClassModel newAttributeNamed: #variableRefs collection: Array of: SPClassToVariableRef.
	aClassModel newAttributeNamed: #traitCompositionString type: String.
	aClassModel newAttributeNamed: #classTraitCompositionString type: String.


]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPGlorpMonticelloClassDiff: aClassModel [

	aClassModel newAttributeNamed: #fromPackage type: SPMonticelloPackage.
	aClassModel newAttributeNamed: #toPackage type: SPMonticelloPackage.
	aClassModel newAttributeNamed: #oldClass type: SPGlorpClass.
	aClassModel newAttributeNamed: #newClass type: SPGlorpClass.

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
SpiderDescriptorSystem >> classModelForSPMethod: aClassModel [

	aClassModel
		newAttributeNamed: #id type: Integer;
		newAttributeNamed: #transaction type: SPGlorpTransaction;
		newAttributeNamed: #selector type: Symbol;
		newAttributeNamed: #source type: String;
		newAttributeNamed: #sourceHash type: ByteArray;
		newAttributeNamed: #selectorRefs collection: Array of: SPMethodToSelectorRef;
		newAttributeNamed: #variableRefs collection: Array of: SPMethodToVariableRef
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPMethodToSelectorRef: aClassModel [

	aClassModel
		newAttributeNamed: #selector type: Symbol;
		newAttributeNamed: #flags type: Integer
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPMethodToVariableRef: aClassModel [

	aClassModel
		newAttributeNamed: #variable type: Symbol;
		newAttributeNamed: #flags type: Integer
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPMonticelloPackage: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #name type: Symbol.	
	aClassModel newAttributeNamed: #mcId type: ByteArray.
	aClassModel newAttributeNamed: #version type: Integer.	
	aClassModel newAttributeNamed: #branch type: String.
	aClassModel newAttributeNamed: #author type: String.
	aClassModel newAttributeNamed: #datetime type: DateAndTime.
	aClassModel newAttributeNamed: #message type: String.
	aClassModel newAttributeNamed: #package type: SPPackage.
	aClassModel newAttributeNamed: #ancestors collection: Array of: SPMonticelloPackage.
	aClassModel newAttributeNamed: #rootId type: Integer.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPMonticelloRepoToPackageRef: aClassModel [

	aClassModel newAttributeNamed: #filename type: String.	
	aClassModel newAttributeNamed: #mcPackage type: SPMonticelloPackage.
]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPMonticelloRepository: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #repoUrl type: String.	
	aClassModel newAttributeNamed: #mcPackageRefs collectionOf: SPMonticelloPackage.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPPackage: aClassModel [

	aClassModel newAttributeNamed: #id type: Integer.
	aClassModel newAttributeNamed: #transaction type: SPGlorpTransaction.
	aClassModel newAttributeNamed: #name type: Symbol.	
	aClassModel newAttributeNamed: #comment type: String.
	aClassModel newAttributeNamed: #packageHash type: ByteArray.	
	aClassModel newAttributeNamed: #classRefs collection: Array of: SPPackageToClassRef.

]

{ #category : #'class models' }
SpiderDescriptorSystem >> classModelForSPPackageToClassRef: aClassModel [

	aClassModel newAttributeNamed: #spiderClass type: SPGlorpClass.	
	aClassModel newAttributeNamed: #category type: Symbol.
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPClassToMethodRef: aDescriptor [

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
		referenceClass: SPMethod;
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
SpiderDescriptorSystem >> descriptorForSPClassToVariableRef: aDescriptor [

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
SpiderDescriptorSystem >> descriptorForSPGitClassDiffRecord: aDescriptor [

	| table |
	
	table := self tableNamed: 'DIFF_GIT_CLASSES'.
	aDescriptor table: table.
	
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #commit;
		join: (Join
			from: (table fieldNamed: 'COMMIT_ID')
			to: ((self tableNamed: 'GIT_COMMITS') fieldNamed: 'ID')).

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
SpiderDescriptorSystem >> descriptorForSPGitCommit: aDescriptor [

	| table |
	
	table := self tableNamed: 'GIT_COMMITS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #shaString to: (table fieldNamed: 'SHA').
	(aDescriptor newMapping: EmbeddedValueOneToOneMapping)
		attributeName: #authorSignature.
	(aDescriptor newMapping: DirectMapping) 
		from: #message to: (table fieldNamed: 'MESSAGE').
	(aDescriptor newMapping: DirectMapping) 
		from: #status to: (table fieldNamed: 'STATUS').
	(aDescriptor newMapping: DirectMapping) 
		from: #rootId to: (table fieldNamed: 'ROOT_ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #sourceDir to: (table fieldNamed: 'SOURCE_DIR').
	(aDescriptor newMapping: DirectMapping) 
		from: #format to: (table fieldNamed: 'FORMAT').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID')).

	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #packages;
		referenceClass: SPPackage;
		orderBy: [ :each | each name ];
		join: (Join
			from: (table fieldNamed: 'ID')
			to: ((self tableNamed: 'GIT_COMMIT_PACK_REFS') fieldNamed: 'COMMIT_ID')).

	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #parents;
		referenceClass: SPGitCommit;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: ((self tableNamed: 'GIT_COMMIT_PARENT_REFS') fieldNamed: 'COMMIT_ID')).
	(aDescriptor newMapping: ManyToManyMapping)
		attributeName: #children;
		beForPseudoVariable;
		referenceClass: SPGitCommit;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: ((self tableNamed: 'GIT_COMMIT_PARENT_REFS') fieldNamed: 'PARENT_ID')).


]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGitMethodDiffRecord: aDescriptor [

	| table |
	
	table := self tableNamed: 'DIFF_GIT_METHODS'.
	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #className to: (table fieldNamed: 'CLASS_NAME').
	(aDescriptor newMapping: DirectMapping) 
		from: #isMeta to: (table fieldNamed: 'META').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #commit;
		join: (Join
			from: (table fieldNamed: 'COMMIT_ID')
			to: ((self tableNamed: 'GIT_COMMITS') fieldNamed: 'ID')).

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #oldMethod;
		join: (Join
			from: (table fieldNamed: 'OLD_METHOD_ID')
			to: ((self tableNamed: 'METHODS') fieldNamed: 'ID')).			

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #newMethod;
		join: (Join
			from: (table fieldNamed: 'NEW_METHOD_ID')
			to: ((self tableNamed: 'METHODS') fieldNamed: 'ID')).
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGitPackageDiffRecord: aDescriptor [

	| table |
	
	table := self tableNamed: 'DIFF_GIT_PACKAGES'.
	aDescriptor table: table.
	
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #commit;
		join: (Join
			from: (table fieldNamed: 'COMMIT_ID')
			to: ((self tableNamed: 'GIT_COMMITS') fieldNamed: 'ID')).

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #oldPackage;
		join: (Join
			from: (table fieldNamed: 'OLD_PACKAGE_ID')
			to: ((self tableNamed: 'PACKAGES') fieldNamed: 'ID')).			

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #newPackage;
		join: (Join
			from: (table fieldNamed: 'NEW_PACKAGE_ID')
			to: ((self tableNamed: 'PACKAGES') fieldNamed: 'ID')).
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGitRepo: aDescriptor [

	| table mapping |
	
	table := self tableNamed: 'GIT_REPOS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #id to: (table fieldNamed: 'ID').
	(aDescriptor newMapping: DirectMapping) 
		from: #url to: (table fieldNamed: 'URL').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #transaction;
		join: (Join
			from: (table fieldNamed: 'TXID')
			to: ((self tableNamed: 'SP_TRANSACTIONS') fieldNamed: 'ID')).

	mapping := (aDescriptor newMapping: ToManyMapping)
		attributeName: #commitRefs;
		referenceClass: SPGitRepoToCommitRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: ((self tableNamed: 'GIT_REPO_REFS') fieldNamed: 'REPO_ID')).
	mapping query 
		shouldRefresh: true;
		alsoFetch: [ :each | each commit ];
		orderBy: [ :each | each commit authorSignature datetime ].

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGitRepoToCommitRef: aDescriptor [

	| table |
	
	table := self tableNamed: 'GIT_REPO_REFS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #type to: (table fieldNamed: 'TYPE').
	(aDescriptor newMapping: DirectMapping) 
		from: #name to: (table fieldNamed: 'NAME').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #commit;
		join: (Join
			from: (table fieldNamed: 'COMMIT_ID')
			to: ((self tableNamed: 'GIT_COMMITS') fieldNamed: 'ID')).
			
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #repo;
		beForPseudoVariable;
		referenceClass: SPGitRepo;
		join: (Join
			from: (table fieldNamed: 'REPO_ID')
			to: ((self tableNamed: 'GIT_REPOS') fieldNamed: 'ID')).


]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGitSignature: aDescriptor [

	| table |
	
	table := self tableNamed: 'GIT_COMMITS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #name to: (table fieldNamed: 'AUTHOR_NAME').
	(aDescriptor newMapping: DirectMapping) 
		from: #email to: (table fieldNamed: 'AUTHOR_EMAIL').
	(aDescriptor newMapping: DirectMapping) 
		from: #datetime to: (table fieldNamed: 'AUTHOR_DATETIME').
	(aDescriptor newMapping: DirectMapping) 
		from: #tzOffset to: (table fieldNamed: 'AUTHOR_TZOFFSET').
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPGlorpClass: aDescriptor [

	| table varRefsTable methodRefsTable mapping |
	
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

	(aDescriptor newMapping: ToManyMapping)
		attributeName: #variableRefs;
		referenceClass: SPClassToVariableRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (varRefsTable fieldNamed: 'CLASS_ID')).
		
	mapping := (aDescriptor newMapping: ToManyMapping)
		attributeName: #methodRefs;
		referenceClass: SPClassToMethodRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (methodRefsTable fieldNamed: 'CLASS_ID')).
	mapping query alsoFetch: [ :each | each method ].
	mapping query orderBy: [ :each | each method selector ].
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
SpiderDescriptorSystem >> descriptorForSPMethod: aDescriptor [

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
		referenceClass: SPMethodToVariableRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (varRefsTable fieldNamed: 'METHOD_ID')).
		
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #selectorRefs;
		referenceClass: SPMethodToSelectorRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (msgSendsTable fieldNamed: 'METHOD_ID')).
			
		
	(aDescriptor newMapping: OneToManyMapping)
		attributeName: #classToMethodRefs;
		beForPseudoVariable;
		referenceClass: SPClassToMethodRef;
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
SpiderDescriptorSystem >> descriptorForSPMethodToSelectorRef: aDescriptor [

	| table |
	
	table := self tableNamed: 'METHOD_SEL_REFS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #selector to: (table fieldNamed: 'SELECTOR').
	(aDescriptor newMapping: DirectMapping) 
		from: #flags to: (table fieldNamed: 'FLAGS').
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPMethodToVariableRef: aDescriptor [

	| table |
	
	table := self tableNamed: 'METHOD_VAR_REFS'.

	aDescriptor table: table.
	
	(aDescriptor newMapping: DirectMapping) 
		from: #variable to: (table fieldNamed: 'VARIABLE').
	(aDescriptor newMapping: DirectMapping) 
		from: #flags to: (table fieldNamed: 'FLAGS').
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPMonticelloPackage: aDescriptor [

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
		referenceClass: SPMonticelloPackage;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (ancestorsRefsTable fieldNamed: 'MC_PACKAGE_ID')).
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPMonticelloRepoToPackageRef: aDescriptor [

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
		attributeName: #repo;
		beForPseudoVariable;
		referenceClass: SPMonticelloRepository;
		join: (Join
			from: (table fieldNamed: 'MC_REPO_ID')
			to: ((self tableNamed: 'MC_REPOS') fieldNamed: 'ID')).


]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPMonticelloRepository: aDescriptor [

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
		referenceClass: SPMonticelloRepoToPackageRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (packageRefsTable fieldNamed: 'MC_REPO_ID')).

]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPPackage: aDescriptor [

	| table classRefsTable mapping |
	
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

	mapping := (aDescriptor newMapping: ToManyMapping)
		attributeName: #classRefs;
		referenceClass: SPPackageToClassRef;
		join: (Join
			from: (table fieldNamed: 'ID')
			to: (classRefsTable fieldNamed: 'PACKAGE_ID')).
	mapping query alsoFetch: [ :each | each spiderClass ].
	mapping query orderBy: [ :each | each spiderClass name ].
]

{ #category : #descriptors }
SpiderDescriptorSystem >> descriptorForSPPackageToClassRef: aDescriptor [

	| table |
	
	table := self tableNamed: 'PACKAGE_CLS_REFS'.

	aDescriptor table: table.
		
	(aDescriptor newMapping: DirectMapping) 
		from: #category to: (table fieldNamed: 'CATEGORY').

	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #spiderClass;
		referenceClass: SPGlorpClass;
		join: (Join
			from: (table fieldNamed: 'CLASS_ID')
			to: ((self tableNamed: 'CLASSES') fieldNamed: 'ID')).
			
	(aDescriptor newMapping: OneToOneMapping)
		attributeName: #package;
		beForPseudoVariable;
		referenceClass: SPPackage;
		join: (Join
			from: (table fieldNamed: 'PACKAGE_ID')
			to: ((self tableNamed: 'PACKAGES') fieldNamed: 'ID')).

	(aDescriptor newMapping: DirectMapping) 
		beForPseudoVariable;
		from: #packageId to: (table fieldNamed: 'PACKAGE_ID').

	(aDescriptor newMapping: DirectMapping) 
		beForPseudoVariable;
		from: #spiderClassId to: (table fieldNamed: 'CLASS_ID').

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
SpiderDescriptorSystem >> tableForDIFF_GIT_CLASSES: aTable [

	aTable createFieldNamed: 'COMMIT_ID' type: platform integer.
	aTable createFieldNamed: 'OLD_CLASS_ID' type: platform integer.
	aTable createFieldNamed: 'NEW_CLASS_ID' type: platform integer.
]

{ #category : #tables }
SpiderDescriptorSystem >> tableForDIFF_GIT_METHODS: aTable [

	aTable createFieldNamed: 'COMMIT_ID' type: platform integer.
	aTable createFieldNamed: 'CLASS_NAME' type: platform varchar.
	aTable createFieldNamed: 'META' type: platform boolean. 
	aTable createFieldNamed: 'OLD_METHOD_ID' type: platform integer.
	aTable createFieldNamed: 'NEW_METHOD_ID' type: platform integer.
]

{ #category : #tables }
SpiderDescriptorSystem >> tableForDIFF_GIT_PACKAGES: aTable [

	aTable createFieldNamed: 'COMMIT_ID' type: platform integer.
	aTable createFieldNamed: 'OLD_PACKAGE_ID' type: platform integer.
	aTable createFieldNamed: 'NEW_PACKAGE_ID' type: platform integer.
]

{ #category : #tables }
SpiderDescriptorSystem >> tableForGIT_COMMITS: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'SHA' type: platform varchar.
	aTable createFieldNamed: 'AUTHOR_DATETIME' type: platform timestamptz.
	aTable createFieldNamed: 'AUTHOR_TZOFFSET' type: platform integer.
	aTable createFieldNamed: 'AUTHOR_NAME' type: platform varchar.
	aTable createFieldNamed: 'AUTHOR_EMAIL' type: platform varchar.
	aTable createFieldNamed: 'MESSAGE' type: platform varchar.
	aTable createFieldNamed: 'STATUS' type: platform varchar.
	aTable createFieldNamed: 'ROOT_ID' type: platform integer.
	aTable createFieldNamed: 'SOURCE_DIR' type: platform varchar.
	aTable createFieldNamed: 'FORMAT' type: platform varchar.
]

{ #category : #tables }
SpiderDescriptorSystem >> tableForGIT_COMMIT_PACK_REFS: aTable [

	| commitIdField packageIdField |

	commitIdField := aTable createFieldNamed: 'COMMIT_ID' type: platform integer.
	packageIdField := aTable createFieldNamed: 'PACKAGE_ID' type: platform integer.

	aTable addForeignKeyFrom: commitIdField to: ((self tableNamed: 'GIT_COMMITS') fieldNamed: 'ID').
	aTable addForeignKeyFrom: packageIdField to: ((self tableNamed: 'PACKAGES') fieldNamed: 'ID').
	

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForGIT_COMMIT_PARENT_REFS: aTable [

	| commitIdField parentIdField |

	commitIdField := aTable createFieldNamed: 'COMMIT_ID' type: platform integer.
	parentIdField := aTable createFieldNamed: 'PARENT_ID' type: platform integer.
	aTable createFieldNamed: 'SEQNR' type: platform integer.
	
	aTable addForeignKeyFrom: commitIdField to: ((self tableNamed: 'GIT_COMMITS') fieldNamed: 'ID').
	aTable addForeignKeyFrom: parentIdField to: ((self tableNamed: 'GIT_COMMITS') fieldNamed: 'ID').
	
	
	

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForGIT_REPOS: aTable [

	(aTable createFieldNamed: 'ID' type: (platform serial)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'URL' type: platform varchar.

]

{ #category : #tables }
SpiderDescriptorSystem >> tableForGIT_REPO_REFS: aTable [

	(aTable createFieldNamed: 'REPO_ID' type: (platform integer)) bePrimaryKey.
	(aTable createFieldNamed: 'TYPE' type: (platform varchar: 1)) bePrimaryKey.
	(aTable createFieldNamed: 'NAME' type: (platform varchar)) bePrimaryKey.
	aTable createFieldNamed: 'TXID' type: platform integer.
	aTable createFieldNamed: 'COMMIT_ID' type: platform integer.

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
