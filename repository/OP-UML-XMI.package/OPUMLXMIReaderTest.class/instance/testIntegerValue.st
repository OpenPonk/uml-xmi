tests - reading - value
testIntegerValue
	| result integerProperty |
	integerProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'lower' ].
	result := reader valueFor: '123' property: integerProperty.
	self assert: result equals: 123