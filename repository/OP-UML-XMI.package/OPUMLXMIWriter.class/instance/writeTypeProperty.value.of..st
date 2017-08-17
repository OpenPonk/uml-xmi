writing
writeTypeProperty: aProperty value: aValue of: anElement
	self assert: [ aProperty name = #type ].
	metamodelPackagedElements
		at: aValue name
		ifPresent: [ ^ {OPXMIReferenceElement new
				xmiName: aProperty name;
				xmiType: 'uml:' , aValue umlClassName;
				href: umlMetamodel URI , '#' , aValue name} ].
	^ self writeNonCompositeProperty: aProperty value: aValue of: anElement