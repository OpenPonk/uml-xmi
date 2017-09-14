instance creation
instanceFor: anObjectElement
	^ instanceCache at: (self uniqueIdOf: anObjectElement)