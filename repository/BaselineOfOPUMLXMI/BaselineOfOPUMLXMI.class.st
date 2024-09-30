"
Baseline for https://github.com/OpenPonk/uml-xmi
"
Class {
	#name : 'BaselineOfOPUMLXMI',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOPUMLXMI',
	#package : 'BaselineOfOPUMLXMI'
}

{ #category : 'baselines' }
BaselineOfOPUMLXMI >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec baseline: 'OPXMI' with: [ spec repository: 'github://openponk/xmi:v4.0.x' ].
			spec
				baseline: 'UMLMetamodel'
				with: [ spec repository: 'github://openponk/uml-metamodel:v4.0.x' ].
			spec package: 'OP-UML-XMI' with: [ spec requires: #('OPXMI' 'UMLMetamodel') ].
			spec group: 'default' with: #('OP-UML-XMI') ]
]
