tests - reading - value
testBooleanStringValue
	| result stringProperty |
	stringProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'name' ].
	result := reader valueFor: 'true' property: stringProperty.
	self assert: result equals: 'true'