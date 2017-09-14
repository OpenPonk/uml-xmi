instance creation
testWriteEnumerationPropertyDefaultValue
	| element property result |
	element := OPUMLPackageableElement new.
	property := element umlMetaClass allAttributes
		detect: [ :each | each name = 'visibility' ].
	result := writer writeEnumerationProperty: property value: element visibility of: element.
	self assert: result equals: #()