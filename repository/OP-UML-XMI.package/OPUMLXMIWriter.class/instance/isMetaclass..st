testing
isMetaclass: aClass
	(aClass oclIsTypeOf: #Class)
		ifFalse: [ ^ false ].
	OPUMLXMISpecsStorage metaClassMap at: aClass name ifPresent: [ :mm | ^ mm = aClass ].
	^ false