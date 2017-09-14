instance creation
createNewInstanceFor: anItem
	| name |
	name := anItem xmiType
		ifNil: [ self assert: [ #(Package Model Profile) includes: anItem xmiName ].
			name := anItem xmiName ]
		ifNotNil: [ :type | (type splitOn: ':') last ].
	^ (self classPrefix , name) asSymbol asClass new