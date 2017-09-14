instance creation
createNewInstanceFor: anItem property: aProperty
	| name |
	name := aProperty
		ifNil: [ "Root elements only"
			self assert: [ #(Package Model Profile) includes: anItem xmiName ].
			anItem xmiName ]
		ifNotNil: [ anItem xmiType
				ifNil: [ aProperty type name ]
				ifNotNil: [ :type | (type splitOn: ':') last ] ].
	^ (self classPrefix , name) asSymbol asClass new