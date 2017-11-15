accessing
primitiveTypeNamed: aPrimitiveName
	"
	PrimitivesMap := nil
	"

	PrimitivesMap
		ifNil: [ PrimitivesMap := (self primitivesMetamodel packagedElements
				collect: [ :each | each name -> each ]) asDictionary ].
	^ PrimitivesMap at: aPrimitiveName