Extension { #name : #ProtoObject }

{ #category : #'*Spider-Model-Core' }
ProtoObject >> logInfo: anObject [

	SPLogger default logInfo: self class name message: anObject
]

{ #category : #'*Spider-Model-Core' }
ProtoObject >> logWarn: anObject [

	SPLogger default logWarn: self class name message: anObject
]
