"
Baseline for https://github.com/OpenPonk/uml-xmi
"
Class {
	#name : 'BaselineOfOpenPonkUMLXMI',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOpenPonkUMLXMI',
	#package : 'BaselineOfOpenPonkUMLXMI'
}

{ #category : 'baselines' }
BaselineOfOpenPonkUMLXMI >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec baseline: 'OpenPonkXMI' with: [ spec repository: 'github://openponk/xmi:v4.1.x' ].
			spec
				baseline: 'OpenPonkUMLMetamodel'
				with: [ spec repository: 'github://openponk/uml-metamodel:v4.1.x' ].
			spec package: 'OpenPonk-UML-XMI' with: [ spec requires: #('OpenPonkXMI' 'OpenPonkUMLMetamodel') ].
			spec group: 'default' with: #('OpenPonk-UML-XMI') ]
]
