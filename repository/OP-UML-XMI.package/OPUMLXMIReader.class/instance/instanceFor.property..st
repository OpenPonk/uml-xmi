instance creation
instanceFor: anObjectElement property: aProperty
	^ instanceCache
		at: (self uniqueIdOf: anObjectElement)
		ifAbsentPut: [ self createNewInstanceFor: anObjectElement property: aProperty ]