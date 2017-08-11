baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec baseline: 'OPXMI' with: [ spec repository: 'github://openponk/xmi/repository' ].
			spec
				baseline: 'UMLMetamodel'
				with: [ spec repository: 'github://openponk/uml-metamodel/repository' ].
			spec package: 'OP-UML-XMI' with: [ spec requires: #('OPXMI' 'UMLMetamodel') ].
			spec group: 'default' with: #('OP-UML-XMI') ]