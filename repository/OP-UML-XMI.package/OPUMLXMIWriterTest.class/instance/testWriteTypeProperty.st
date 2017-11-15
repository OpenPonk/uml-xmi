tests
testWriteTypeProperty
	| element property result comment commentXmi |
	comment := OPUMLClass new name: 'Comment'.
	element := OPUMLProperty new.
	element type: comment.
	commentXmi := writer writeElement: comment.
	property := element umlMetaClass allAttributes detect: [ :each | each name = 'type' ].
	result := writer writeTypeProperty: property value: comment of: element.
	writer resolveReferences.
	self assert: result first referencedElement equals: commentXmi