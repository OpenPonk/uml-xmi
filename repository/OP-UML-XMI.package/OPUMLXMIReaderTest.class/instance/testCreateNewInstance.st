tests
testCreateNewInstance
	self assert: (reader createNewInstanceFor: 'uml:Class') umlClassName equals: #Class