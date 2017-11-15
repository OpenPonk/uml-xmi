initialization
initialize
	super initialize.
	unresolved := OrderedCollection new.
	identityCache := Dictionary new.
	classPrefix := self defaultClassPrefix.
	stereotypes := OrderedCollection new.
	umlMetamodel := OPUMLXMISpecsStorage umlMetamodel