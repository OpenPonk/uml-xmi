reading
readProfileItem: anItem property: aProperty
	| parts factory |
	parts := anItem href splitOn: '#'.
	self class environment
		at: #OPUmlCustomProfile
		ifPresent: [ :cls | 
			factory := cls withAllSubclasses
				detect: [ :each | each profile URI = parts first ]
				ifNone: [ self error: 'No profile with URI ' , parts first , ' found' ] ]
		ifAbsent: [  ].
	^ factory profile