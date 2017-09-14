running
property: aPropertyName in: aContainerClass
	^ (OPUMLXMISpecsStorage metaClassFor: aContainerClass) ownedAttributes
		detect: [ :each | each name = aPropertyName ]