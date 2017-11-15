accessing
loadMetamodel
	"
	UmlMetaModel := nil.
	PrimitivesMetaModel := nil.
	"

	<script: 'self loadMetamodel inspect'>
	| pathmap result packages xmiDom models |
	pathmap := OPUMLXMIPathmap new.
	pathmap add: 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi'.
	pathmap add: 'http://www.omg.org/spec/UML/20131001/UML.xmi'.
	result := OPXMIReader readFromMapping: pathmap mapping.
	packages := result values
		flatCollect: [ :xmi | 
			xmi containedItems
				select: [ :each | each isObjectElement and: [ each xmiName = 'Package' ] ] ].
	(packages first containedItems
		detect: [ :each | each isValueAttribute and: [ each xmiName = 'xmi:id' ] ]) value: '_1'.
	xmiDom := OPXMIObjectElement new containedItems: packages.
	models := OPUMLXMIMetaReader new readXmi: xmiDom.
	PrimitivesMetaModel := models first.
	UmlMetaModel := models second.
	^ {PrimitivesMetaModel.
	UmlMetaModel}