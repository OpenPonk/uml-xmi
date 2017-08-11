tests
testReadTrivialishXmi
	| result |
	result := reader readXmi: self trivialishXmi.
	self assert: result size equals: 1.
	self assert: result first umlClassName equals: #Package.
	self assert: result first packagedElements size equals: 1.
	self assert: result first packagedElements first name equals: 'Activities'