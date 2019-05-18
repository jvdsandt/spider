Class {
	#name : #BaselineOfSpider,
	#superclass : #BaselineOf,
	#category : #BaselineOfSpider
}

{ #category : #baselines }
BaselineOfSpider >> baselineOf: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec baseline: 'P3' with: [ 
				spec 
					repository: 'github://svenvc/P3:master/repository';
					loads: 'glorp' ].
			spec baseline: 'Seaside3' with: [ 
				spec 
					repository: 'github://SeasideSt/Seaside:v3.3.3/repository';
					loads: #( 'Core' 'JSON' 'Javascript' 'JQuery' 'Zinc' ) ].

			spec package: 'Spider-Compatibility' with: [ spec requires: #('P3') ].
			spec package: 'Spider-Model' with: [ spec requires: #('Spider-Compatibility') ].
			spec package: 'Spider-Model-Tests' with: [ spec requires: #('Spider-Model') ].
			spec package: 'Spider-MCModel' with: [ spec requires: #('Spider-Model') ].
			spec package: 'Spider-MCModel-Tests' with: [ spec requires: #('Spider-MCModel') ].
			spec package: 'Spider-GitModel' with: [ spec requires: #('Spider-Model') ].
			spec package: 'Spider-GitModel-Tests' with: [ spec requires: #('Spider-GitModel') ].

			spec package: 'Spider-WebAPI' with: [ spec requires: #( 'Spider-Model' 'Seaside3') ].
			spec package: 'Spider-WebUI' with: [ spec requires: #( 'Spider-Model' 'Seaside3') ].
			
			spec group: 'default' with: #('core' 'tests').
			spec group: 'core' with: #('Spider-Model' 'Spider-MCModel' 'Spider-GitModel' ).
			spec group: 'tests' with: #('Spider-Model-Tests' 'Spider-MCModel-Tests' 'Spider-GitModel-Tests' ) ]
]
