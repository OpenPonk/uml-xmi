tests
testReadImportedType
	| result property |
	property := (self metaClassNamed: #Class) allAttributes
		detect: [ :each | each name = 'ownedAttribute' ].
	result := reader readItem: self attributeWithHrefType property: property.
	self assert: result type equals: (self metaClassNamed: #Association)