Extension { #name : #ProtoObject }

{ #category : #'*Spider-Model-Core' }
ProtoObject >> logInfo: anObject [

	SPLogger default logInfo: self class name message: anObject
]
