tests - stereotypes
testWriteAppliedProfile
	| profile application result property |
	profile := OPUMLProfile new
		name: 'TestProfile';
		uuid: 'id0';
		URI: 'http://www.example.com/TestProfile'.
	application := OPUMLProfileApplication new
		uuid: 'MyPackage-_profileApplication.0';
		appliedProfile: profile.
	property := application umlMetaClass allAttributes
		detect: [ :each | each name = 'appliedProfile' ].
	result := writer
		writeNonCompositeProperty: property
		value: application appliedProfile
		of: application.
	writer resolveReferences.
	self assert: result first href equals: 'http://www.example.com/TestProfile#id0'