tests
testGeneralizationElement
	| result |
	result := reader readItem: self generalizationElement.
	self assert: result umlClassName equals: 'Generalization'.
	self assert: result general name equals: 'Element'