tests
testWriteMetamodelTypeProperty
	| element property result comment commentXmi |
	comment := OPUMLXMISpecsStorage metaClassNamed: #Comment.
	element := OPUMLProperty new.
	element type: comment.
	commentXmi := writer writeElement: comment.
	self assert: commentXmi equals: #().
	property := element umlMetaClass allAttributes detect: [ :each | each name = 'type' ].
	result := writer writeTypeProperty: property value: comment of: element.
	writer resolveReferences.
	self assert: result first referencedElement equals: nil