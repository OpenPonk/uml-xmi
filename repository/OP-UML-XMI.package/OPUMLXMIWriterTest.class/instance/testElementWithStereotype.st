tests - stereotypes
testElementWithStereotype
	| result element package profile issueTag |
	profile := IPIssuesProfileFactory profile.
	package := OPUMLPackage new name: 'TestPackage'.
	package profileApplications
		add:
			(OPUMLProfileApplication new
				uuid: package uuid , '-_profileApplication.0';
				appliedProfile: profile).
	issueTag := profile ownedStereotype detect: [ :each | each name = 'IssueTag' ].
	element := OPUMLElement new uuid: 'Element'.
	package packagedElements add: element.
	element applyStereotype: issueTag implementationClass new.
	element appliedStereotypes first reviewed: true.
	result := (writer write: package) containedItems last.
	self assert: result xmiName equals: 'IssuesProfile:IssueTag'.
	self assert: result containedItems second xmiName equals: 'reviewed'.
	self assert: result containedItems second value equals: 'true'