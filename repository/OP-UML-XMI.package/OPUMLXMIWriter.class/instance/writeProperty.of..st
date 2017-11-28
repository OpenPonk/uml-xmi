writing
writeProperty: aProperty of: anElement
	| accessor value |
	accessor := self accessorNameFor: aProperty.
	aProperty isDerived
		ifTrue: [ ^ #() ].
	value := anElement perform: accessor asSymbol.
	(value isNil or: [ value isCollection and: [ value isEmpty ] ])
		ifTrue: [ ^ #() ].
	(aProperty type oclIsKindOf: #PrimitiveType)
		ifTrue: [ ^ self writePrimitiveProperty: aProperty value: value of: anElement ].
	(aProperty type oclIsKindOf: #Enumeration)
		ifTrue: [ ^ self writeEnumerationProperty: aProperty value: value of: anElement ].
	(aProperty name = #type and: [ (anElement oclIsKindOf: #TypedElement) ])
		ifTrue: [ ^ self writeTypeProperty: aProperty value: value of: anElement ].
	aProperty isComposite
		ifFalse: [ ^ self writeNonCompositeProperty: aProperty value: value of: anElement ].
	self assert: [ aProperty isComposite ].
	aProperty name = 'metamodelReference'
		ifTrue: [ ^ self writeNonCompositeProperty: aProperty value: value of: anElement ].
	^ self writeCompositeProperty: aProperty value: value of: anElement