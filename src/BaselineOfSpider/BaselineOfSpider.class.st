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
			spec baseline: 'OSSubprocess' with: [ 
				spec 
					repository: 'github://pharo-contributions/OSSubprocess:v1.0.1/repository';
					loads: 'OSSubprocess' ].
			spec baseline: 'P3' with: [ 
				spec 
					repository: 'github://svenvc/P3:master/repository';
					loads: 'glorp' ].
			spec baseline: 'AWSToolbox' with: [ 
				spec 
					repository: 'github://jvdsandt/pharo-aws-toolbox/repository';
					loads: #( 'Core' ) ].
			spec baseline: 'Seaside3' with: [ 
				spec 
					repository: 'github://SeasideSt/Seaside:v3.3.4/repository';
					loads: #( 'Core' 'JSON' 'Javascript' 'JQuery' 'REST' 'Zinc' ) ].
			spec baseline: 'Bootstrap' with: [ 
				spec 
					repository: 'github://jvdsandt/Seaside-Bootstrap:master/src';
					loads: #( 'Core' ) ].

			spec package: 'Spider-Model-Core'.
			spec package: 'Spider-Model-Core-Tests' with: [ spec requires: #('Spider-Model-Core') ].
			spec package: 'Spider-Model-MC' with: [ spec requires: #('Spider-Model-Core') ].
			spec package: 'Spider-Model-MC-Tests' with: [ spec requires: #( 'Spider-Model-Core-Tests' 'Spider-Model-Core') ].
			spec package: 'Spider-Model-Git' with: [ spec requires: #('Spider-Model-MC') ].
			spec package: 'Spider-Model-Git-Tests' with: [ spec requires: #('Spider-Model-MC-Tests' 'Spider-Model-Git') ].
			spec package: 'Spider-Model-RDB' with: [ spec requires: #( 'Spider-Model-Git' 'P3' ) ].
			spec package: 'Spider-Model-RDB-Tests' with: [ spec requires: #( 'Spider-Model-Git-Tests' 'Spider-Model-RDB' ) ].
			spec package: 'Spider-Model-Ring2' with: [ spec requires: #( 'Spider-Model-Core' ) ].
			spec package: 'Spider-Model-Ring2-Tests' with: [ spec requires: #( 'Spider-Model-Ring2' ) ].

			spec package: 'Spider-Import-MC' with: [ spec requires: #( 'Spider-Model-MC' 'Spider-Model-Git' 'Spider-Model-RDB' 'OSSubprocess' ) ].
			spec package: 'Spider-Import-LambdaHooks' with: [ spec requires: #( 'AWSToolbox' ) ].

			spec package: 'Spider-Web-Core' with: [ spec requires: #( 'Spider-Model-RDB' 'Seaside3' 'Bootstrap' ) ].
			spec package: 'Spider-Web-API' with: [ spec requires: #( 'Spider-Web-Core' )].
			spec package: 'Spider-Web-Browser' with: [ spec requires: #( 'Spider-Web-Core' ) ].
			
			spec package: 'Spider-Model-FixScripts' with: [ spec requires: #( 'Spider-Model-RDB' ) ].
			
			spec group: 'default' with: #('core' 'tests').
			spec group: 'core' with: #('Spider-Model-Core' 'Spider-Model-MC' 'Spider-Model-Git' ).
			spec group: 'tests' with: #('Spider-Model-Core-Tests' 'Spider-Model-MC-Tests' 'Spider-Model-Git-Tests' ).
			
			spec group: 'importer' with: #( 'default' 'P3' 'Spider-Import-MC' 'Spider-Model-RDB-Tests' ).
			spec group: 'all' with: #( 'default' 
				'Spider-Model-RDB-Tests' 
				'Spider-Import-MC' 
				'Spider-Web-API' 
				'Spider-Web-Browser' 
				'Spider-Model-Ring2-Tests' 
				'Spider-Model-FixScripts' ) ].
		
	spec for: #( #'pharo7.x' ) do: [ 
		spec baseline: 'Ring2' with: [ 
			spec 
				repository: 'github://jvdsandt/Ring2/src';
				loads: 'core' ].
		spec package: 'Spider-Model-Ring2' with: [ spec requires: #( 'Ring2' ) ] ].
	
	spec for: #( #'pharo8.x' ) do: [ 
		spec package: 'Spider-Pharo8-Support'.
		spec package: 'Spider-Pharo8-Support-Tests' with: [ spec requires: 'Spider-Pharo8-Support' ].

		spec package: 'Spider-Model-Git' with: [ spec requires: #( 'Spider-Pharo8-Support' ) ] ]
]
