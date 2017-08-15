writing
writeNonCompositeProperty: aProperty value: aValue of: anElement
	| values referenceItem |
	(aProperty opposite isNil or: [ aProperty opposite isComposite ])
		ifTrue: [ ^ #() ].
	values := aProperty isMultivalued
		ifTrue: [ values := aValue asArray ]
		ifFalse: [ values := {aValue} ].
	(values anyOne isKindOf: OPUMLPrimitiveType)
		ifTrue: [ ^ values
				collect: [ :each | 
					(OPXMIReferenceElement xmiName: aProperty name referencedElements: {})
						xmiType: 'uml:PrimitiveType';
						href: self umlUri , '#' , each name ] ]
		ifFalse:
			[ referenceItem := OPXMIReferenceAttribute xmiName: aProperty name referencedElements: {}.
			unresolved
				add:
					[ referenceItem referencedElements: (values collect: [ :each | self referenceFor: each ]) ].
			^ {referenceItem} ]