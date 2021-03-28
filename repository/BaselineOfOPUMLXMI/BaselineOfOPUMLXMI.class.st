"
Baseline for https://github.com/OpenPonk/uml-xmi
"
Class {
	#name : #BaselineOfOPUMLXMI,
	#superclass : #BaselineOf,
	#category : #BaselineOfOPUMLXMI
}

{ #category : #baselines }
BaselineOfOPUMLXMI >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec baseline: 'OPXMI' with: [ spec repository: 'github://openponk/xmi:v2.1.x/repository' ].
			spec
				baseline: 'UMLMetamodel'
				with: [ spec repository: 'github://openponk/uml-metamodel:v2.1.x/repository' ].
			spec package: 'OP-UML-XMI' with: [ spec requires: #('OPXMI' 'UMLMetamodel') ].
			spec group: 'default' with: #('OP-UML-XMI') ]
]
