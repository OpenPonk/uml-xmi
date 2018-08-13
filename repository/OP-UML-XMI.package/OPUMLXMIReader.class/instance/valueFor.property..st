reading
valueFor: anObject property: aProperty
	(#('Integer') includes: aProperty type name)
		ifTrue: [ ^ Number readFromString: anObject ].
	aProperty type name = 'UnlimitedNatural'
		ifTrue: [ anObject = '*'
				ifTrue: [ ^ anObject ].
			^ Number readFromString: anObject ].
	aProperty type name = 'String'
		ifTrue: [ ^ anObject asString ].
	aProperty type name = 'Boolean'
		ifTrue: [ self assert: [ #('true' 'false') includes: anObject ] description: 'Unexpected type'.
			^ anObject = 'true' ].
	self error: 'Guessed type.'.
	(NumberParser isNumber: anObject)
		ifTrue: [ ^ Number readFromString: anObject ].
	^ anObject