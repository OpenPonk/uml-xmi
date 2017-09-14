tests
testAssociation
	| result |
	result := reader readItem: self association property: packagedElementProperty.
	self assert: result umlClassName equals: #Association.
	self assert: result memberEnds size equals: 2.
	self assert: result memberEnds second equals: result ownedEnds first