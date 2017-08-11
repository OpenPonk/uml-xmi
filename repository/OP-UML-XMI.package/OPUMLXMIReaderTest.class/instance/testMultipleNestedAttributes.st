tests
testMultipleNestedAttributes
	| result |
	result := reader readItem: self multipleNestedAttributes.
	self assert: result umlClassName equals: #Class.
	self assert: result ownedAttributes size equals: 2.
	self assert: result ownedAttributes first name equals: 'annotatedElement'.
	self assert: result ownedAttributes second name equals: 'body'