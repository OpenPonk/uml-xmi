tests
testCreateNewInstanceXmiType
	| item |
	item := OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems: {OPXMIValueElement xmiName: 'xmi:type' value: 'uml:Class'}.
	self
		assert: (reader createNewInstanceFor: item property: packagedElementProperty) umlClassName
		equals: #Class