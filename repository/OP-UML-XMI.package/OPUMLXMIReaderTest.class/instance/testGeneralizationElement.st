tests
testGeneralizationElement
	| result |
	result := reader
		readItem: self generalizationElement
		property: (self property: #generalization in: OPUMLClassifier new).
	self assert: result umlClassName equals: 'Generalization'.
	self assert: result general name equals: 'Element'