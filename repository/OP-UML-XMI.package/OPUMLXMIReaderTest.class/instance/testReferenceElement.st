tests
testReferenceElement
	| result gen |
	result := reader readItem: self elementWithGeneralization.
	self assert: result name equals: 'Comment'.
	gen := result generalizations first.
	self assert: gen umlClassName equals: #Generalization.
	self assert: gen general name equals: 'Element'