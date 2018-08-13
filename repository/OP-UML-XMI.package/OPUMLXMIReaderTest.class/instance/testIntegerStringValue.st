tests - reading - value
testIntegerStringValue
	| result stringProperty |
	stringProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'name' ].
	result := reader valueFor: '123' property: stringProperty.
	self assert: result equals: '123'