instance creation
createNewInstanceFor: anItem property: aProperty
	| name |
	name := (#(Package Model Profile) includes: anItem xmiName)
		ifTrue: [ anItem xmiName ]
		ifFalse: [ anItem xmiType
				ifNil: [ self error: 'Unknown element type.' ]
				ifNotNil: [ :type | (type splitOn: ':') last ] ].
	^ (self classPrefix , name) asSymbol asClass new