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

			spec package: 'Spider-Model-Core'.
			spec package: 'Spider-Model-Core-Tests' with: [ spec requires: #('Spider-Model-Core') ].
			spec package: 'Spider-Model-MC' with: [ spec requires: #('Spider-Model-Core') ].
			spec package: 'Spider-Model-MC-Tests' with: [ spec requires: #( 'Spider-Model-Core-Tests' 'Spider-Model-Core') ].
			spec package: 'Spider-Model-Git' with: [ spec requires: #('Spider-Model-MC') ].
			spec package: 'Spider-Model-Git-Tests' with: [ spec requires: #('Spider-Model-MC-Tests' 'Spider-Model-Git') ].

			spec package: 'Spider-Web-Core' with: [ spec requires: #( 'Spider-Model-Git' 'P3' 'Seaside3') ].
			
			spec group: 'default' with: #('core' 'tests').
			spec group: 'core' with: #('Spider-Model-Core' 'Spider-Model-MC' 'Spider-Model-Git' ).
			spec group: 'tests' with: #('Spider-Model-Core-Tests' 'Spider-Model-MC-Tests' 'Spider-Model-Git-Tests' ) ]
]
