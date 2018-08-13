reading
readItem: anItem property: aProperty
	| instance groups |
	anItem isValueItem
		ifTrue: [ ^ self valueFor: anItem value property: aProperty ].
	anItem isReferenceItem
		ifTrue: [ aProperty name = 'appliedProfile'
				ifTrue: [ ^ self readProfileItem: anItem property: aProperty ].
			(anItem href isNotNil and: [ anItem href beginsWith: 'http://www.omg.org/spec/UML/' ])
				ifTrue: [ ^ self readMetamodelItem: anItem property: aProperty ].
			(anItem href isNotNil and: [ anItem href beginsWith: 'http://schema.omg.org/spec/MOF/' ])
				ifTrue: [ ^ self readMofItem: anItem property: aProperty ].
			^ anItem referencedElements
				collect: [ :each | self readItem: each property: aProperty ] ].
	instanceCache at: (self uniqueIdOf: anItem) ifPresent: [ :match | ^ match ].
	instance := self instanceFor: anItem property: aProperty.
	groups := self groupedChildrenIn: anItem.
	groups
		keysAndValuesDo: [ :key :values | self readPropertyNamed: key values: values instance: instance ].
	^ instance