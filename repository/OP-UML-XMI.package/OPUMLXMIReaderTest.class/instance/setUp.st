running
setUp
	reader := OPUMLXMIReader new.
	packagedElementProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLPackage new)
		ownedAttributes detect: [ :each | each name = 'packagedElement' ]