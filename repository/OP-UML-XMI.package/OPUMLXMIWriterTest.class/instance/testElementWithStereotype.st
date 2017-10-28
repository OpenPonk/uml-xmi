tests - stereotypes
testElementWithStereotype
	| result element package profile |
	profile := self createTestProfile.
	package := OPUMLPackage new
		name: 'TestPackage';
		uuid: 'TestPackage'.
	package profileApplications
		add:
			(OPUMLProfileApplication new
				uuid: package uuid , '-_profileApplication.0';
				appliedProfile: profile).
	element := OPUMLElement new uuid: 'Element'.
	package packagedElements add: element.
	element
		applyStereotype: (profile packagedElements detect: [ :each | each name = 'IssueTag' ]).
	result := (writer write: package) containedItems last.
	self assert: result xmiName equals: 'TestProfile:IssueTag'