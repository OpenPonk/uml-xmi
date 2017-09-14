tests
testInstance
	| element result1 result2 |
	element := OPXMIObjectElement new
		xmiName: 'Package';
		containedItems: {OPXMIValueElement xmiName: 'xmi:id' value: 'CLS'}.
	result1 := reader instanceFor: element property: nil.
	self assert: result1 umlClassName equals: #Package.
	result2 := reader instanceFor: element property: nil.
	self assert: result1 == result2 description: 'We expect the same object.'