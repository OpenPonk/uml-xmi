writing
writeProperty: aProperty of: anElement
	| accessor value |
	accessor := self accessorNameFor: aProperty.
	value := anElement perform: accessor asSymbol.
	(value isNil or: [ value isCollection and: [ value isEmpty ] ])
		ifTrue: [ ^ #() ].
	(aProperty type oclIsKindOf: #PrimitiveType)
		| (aProperty type oclIsKindOf: #Enumeration)
		ifTrue: [ ^ self writePrimitiveProperty: aProperty value: value of: anElement ].
	^ aProperty isComposite
		ifTrue: [ self writeCompositeProperty: aProperty value: value of: anElement ]
		ifFalse: [ self writeNonCompositeProperty: aProperty value: value of: anElement ]