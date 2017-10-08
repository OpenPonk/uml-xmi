initialization
initialize
	super initialize.
	unresolved := OrderedCollection new.
	identityCache := Dictionary new.
	classPrefix := self defaultClassPrefix.
	umlMetamodel := OPUMLXMISpecsStorage umlMetamodel.
	metamodelPackagedElements := ((umlMetamodel packagedElements
		flatCollect: #packagedElements) collect: [ :each | each name -> each ]) asDictionary