tests
testRetrieve
	| storage contents |
	storage := OPUMLXMISpecsStorage new.
	contents := storage at: 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi'.
	self assert: contents isNotEmpty.
	self
		assert: ((XMLDOMParser parse: contents) root firstElement attributeAt: #name)
		equals: 'PrimitiveTypes'