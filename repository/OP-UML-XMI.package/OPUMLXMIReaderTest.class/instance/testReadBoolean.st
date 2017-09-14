tests
testReadBoolean
	| result |
	result := reader
		readItem: (OPXMIValueAttribute xmiName: 'isDerived' value: 'true')
		property: (self property: #isDerived in: OPUMLProperty new).
	self assert: result equals: true