tests
testReadPrimitiveType
	| result property |
	property := (self metaClassNamed: #Class) allAttributes
		detect: [ :each | each name = 'ownedAttribute' ].
	result := reader readItem: self attributeWithPrimitiveType property: property.
	self assert: result type equals: (self primitiveTypeNamed: #Boolean)