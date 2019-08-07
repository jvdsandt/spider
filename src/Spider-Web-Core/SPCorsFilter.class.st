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
	aRequestContext response
		headerAt: 'Access-Control-Allow-Origin' put: '*';
		headerAt: 'Access-Control-Allow-Headers' put: 'Content-Type'.
	aRequestContext request method = 'OPTIONS'
		ifTrue: [
			aRequestContext respond: [ :response |
				response
					status: 204;
					headerAt: 'Access-Control-Allow-Methods' put: 'GET, POST, OPTIONS';
					headerAt: 'Access-Control-Max-Age' put: 1728000 ] ].

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
