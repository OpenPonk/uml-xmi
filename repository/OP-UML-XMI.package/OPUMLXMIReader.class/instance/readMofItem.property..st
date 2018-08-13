reading
readMofItem: anItem property: aProperty
	| parts |
	parts := anItem href splitOn: '#'.
	^ OPUMLXMISpecsStorage primitiveTypeNamed: parts second