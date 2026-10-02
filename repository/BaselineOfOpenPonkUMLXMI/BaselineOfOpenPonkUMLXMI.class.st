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
		do: [ spec baseline: 'OpenPonkXMI' with: [ spec repository: 'github://OpenPonk/xmi' ].
			spec
				baseline: 'OpenPonkUMLMetamodel'
				with: [ spec repository: 'github://OpenPonk/uml-metamodel' ].
			spec package: 'OpenPonk-UML-XMI' with: [ spec requires: #('OpenPonkXMI' 'OpenPonkUMLMetamodel') ].
			spec group: 'default' with: #('OpenPonk-UML-XMI') ]
]
