reading
readMetamodelItem: anItem property: aProperty
	| parts |
	parts := anItem href splitOn: '#'.
	(parts first endsWith: 'PrimitiveTypes.xmi')
		ifTrue: [ ^ OPUMLXMISpecsStorage primitiveTypeNamed: parts second ].
	(parts first endsWith: 'UML.xmi')
		ifTrue: [ ^ OPUMLXMISpecsStorage metaClassNamed: parts second ].
	self error: 'Unknown type at ' , anItem href