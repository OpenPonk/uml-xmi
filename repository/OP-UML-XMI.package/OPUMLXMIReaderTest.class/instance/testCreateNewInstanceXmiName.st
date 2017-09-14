tests
testCreateNewInstanceXmiName
	| item |
	item := OPXMIObjectElement new
		xmiName: 'Package';
		containedItems: {}.
	self
		assert: (reader createNewInstanceFor: item property: nil) umlClassName
		equals: #Package