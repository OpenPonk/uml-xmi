writing
writeEnumerationProperty: aProperty value: aValue of: anElement
	| values |
	(aProperty defaultValue isNotNil and: [ aProperty defaultValue instance name = aValue ])
		ifTrue: [ ^ #() ].
	values := aProperty isMultivalued
		ifTrue: [ values := aValue asArray ]
		ifFalse: [ values := {aValue} ].
	^ values collect: [ :each | OPXMIValueAttribute xmiName: aProperty name value: each asString ]