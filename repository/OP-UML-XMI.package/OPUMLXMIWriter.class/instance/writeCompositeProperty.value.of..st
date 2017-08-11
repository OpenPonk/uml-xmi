writing
writeCompositeProperty: aProperty value: aValue of: anElement
	| values |
	values := aProperty isMultivalued
		ifTrue: [ values := aValue asArray ]
		ifFalse: [ values := {aValue} ].
	^ values
		collect: [ :each | 
			| el |
			el := self writeElement: each.
			el xmiName: aProperty name ]