Class {
	#name : #SPCorsFilter,
	#superclass : #WARequestFilter,
	#category : #'Spider-Web-Core-Seaside'
}

{ #category : #processing }
SPCorsFilter >> accessControlAllowHeaders [

	^ 'User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range'
]

{ #category : #processing }
SPCorsFilter >> handleFiltered: aRequestContext [ 
	aRequestContext request method = 'OPTIONS'
		ifTrue: [ ^ self handleOptions: aRequestContext ].
	aRequestContext response
		headerAt: 'Access-Control-Allow-Origin' put: '*';
		headerAt: 'Access-Control-Allow-Headers' put: self accessControlAllowHeaders;
		headerAt: 'Access-Control-Expose-Headers' put: 'Content-Length'.

	^ super handleFiltered: aRequestContext

]

{ #category : #processing }
SPCorsFilter >> handleOptions: aRequestContext [

	aRequestContext respond: [ :response |
		response
			status: 204;
			headerAt: 'Access-Control-Allow-Origin' put: '*';
			headerAt: 'Access-Control-Allow-Methods' put: 'GET, POST, OPTIONS';
			headerAt: 'Access-Control-Allow-Headers' put: self accessControlAllowHeaders ]
]
