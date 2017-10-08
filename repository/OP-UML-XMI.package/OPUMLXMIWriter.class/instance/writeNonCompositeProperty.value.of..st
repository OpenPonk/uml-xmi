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
						href: self umlUri , '#' , each name ] ].
	(#(importedPackage appliedProfile) includes: aProperty name)
		ifTrue: [ referenceItem := OPXMIReferenceElement xmiName: aProperty name referencedElements: {}.
			unresolved
				add: [ self assert: [ aProperty isMultivalued not ].
					identityCache
						at: values anyOne
						ifPresent: [ :ref | referenceItem referencedElements: {ref} ]
						ifAbsent: [ referenceItem href: values anyOne URI , '#' , values anyOne uuid ] ].
			^ {referenceItem} ].
	referenceItem := OPXMIReferenceAttribute xmiName: aProperty name referencedElements: {}.
	unresolved
		add:
			[ referenceItem referencedElements: (values collect: [ :each | self referenceFor: each ]) ].
	^ {referenceItem}