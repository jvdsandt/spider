Class {
	#name : #SPFixDuplicateClassCategories,
	#superclass : #SPBatchOperation,
	#category : #'Spider-Model-FixScripts'
}

{ #category : #execution }
SPFixDuplicateClassCategories >> execute [

	| result packageIds |

	result := self p3client query: 'select distinct p.id from package_cls_refs pcr join packages p on pcr.package_id = p.id where p.name = pcr.category'.
	packageIds := result data collect: [ :eachRow | eachRow first ].
	
	packageIds isEmpty
		ifTrue: [ ^ self ].

	self context 
		doTransaction: (self class name, ' - rehashing packages') asString
		with: [ 
			self p3client execute: 'update package_cls_refs set category = null 
				from packages p 
				where p.id = package_cls_refs.package_id and p.name = package_cls_refs.category'.
	
			self rehashPackageIds: packageIds txid: self context currentTransactionId ]
	

]
