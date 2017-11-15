writing
writeTypeProperty: aProperty value: aValue of: anElement
	self assert: [ aProperty name = #type ].
	(self isMetaclass: aValue)
		ifTrue: [ ^ {OPXMIReferenceElement new
				xmiName: aProperty name;
				xmiType: 'uml:' , aValue umlClassName;
				href: self metamodelUri , '#' , aValue name} ].
	^ self writeNonCompositeProperty: aProperty value: aValue of: anElement