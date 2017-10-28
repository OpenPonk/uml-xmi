support
newStereotype: aName to: aBaseClass
	| stereotype baseName extension baseProperty extensionProperty |
	baseName := aBaseClass name.
	stereotype := OPUMLStereotype new name: aName.
	stereotype uuid: stereotype name.
	extension := OPUMLExtension new name: baseName , '_' , aName.
	extension uuid: extension name.
	(baseProperty := OPUMLProperty new)
		name: 'base_' , baseName;
		uuid: stereotype uuid , '-' , baseProperty name;
		owningClass: stereotype;
		type: aBaseClass.
	(extensionProperty := OPUMLProperty new)
		name: 'extension_' , stereotype name;
		uuid: extension uuid , '-' , extensionProperty name;
		owningAssociation: extension;
		aggregation: OPUMLAggregationKind composite;
		type: stereotype.
	extension
		memberEnds:
			{baseProperty.
			extensionProperty}.
	extension ownedEnd: extensionProperty.
	extensionProperty
		lowerValue:
			(OPUMLLiteralInteger new
				value: 0;
				uuid: extensionProperty uuid , '-_lowerValue').
	^ {stereotype.
	extension}