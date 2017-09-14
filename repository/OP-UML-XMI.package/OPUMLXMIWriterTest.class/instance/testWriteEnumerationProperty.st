instance creation
testWriteEnumerationProperty
	| element property result |
	element := OPUMLPackageableElement new.
	element visibility: OPUMLVisibilityKind private.
	property := element umlMetaClass allAttributes
		detect: [ :each | each name = 'visibility' ].
	result := writer writeEnumerationProperty: property value: element visibility of: element.
	self assert: result equals: {OPXMIValueAttribute xmiName: 'visibility' value: 'private'}