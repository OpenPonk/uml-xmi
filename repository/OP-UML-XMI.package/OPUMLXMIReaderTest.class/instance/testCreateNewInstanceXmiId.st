tests
testCreateNewInstanceXmiId
	| item |
	item := OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems: {OPXMIValueElement xmiName: 'xmi:id' value: 'CustomId'}.
	self
		assert: (reader createNewInstanceFor: item property: packagedElementProperty) uuid
		equals: 'CustomId'