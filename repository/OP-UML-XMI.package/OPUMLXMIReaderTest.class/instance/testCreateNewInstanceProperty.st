tests
testCreateNewInstanceProperty
	| item property |
	item := OPXMIObjectElement new
		xmiName: 'profileApplication';
		containedItems: {}.
	property := (OPUMLXMISpecsStorage metaClassFor: OPUMLPackage new) ownedAttributes
		detect: [ :each | each name = 'profileApplication' ].
	self
		assert: (reader createNewInstanceFor: item property: property) umlClassName
		equals: #ProfileApplication