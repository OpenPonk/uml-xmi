tests - reading - value
testBooleanValue
	| result booleanProperty |
	booleanProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) ownedAttributes
		detect: [ :each | each name = 'isDerived' ].
	result := reader valueFor: 'true' property: booleanProperty.
	self assert: result equals: true