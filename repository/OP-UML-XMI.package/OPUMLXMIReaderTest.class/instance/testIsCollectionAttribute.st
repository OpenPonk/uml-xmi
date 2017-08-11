tests
testIsCollectionAttribute
	self deny: (reader isCollectionAttribute: #name inClass: OPUMLProperty).
	self deny: (reader isCollectionAttribute: #body inClass: OPUMLComment).
	self deny: (reader isCollectionAttribute: #general inClass: OPUMLGeneralization).
	self deny: (reader isCollectionAttribute: #type inClass: OPUMLProperty).
	self deny: (reader isCollectionAttribute: #importedPackage inClass: OPUMLPackageImport).
	self deny: (reader isCollectionAttribute: #defaultValue inClass: OPUMLProperty).
	self deny: (reader isCollectionAttribute: #instance inClass: OPUMLInstanceValue).
	self deny: (reader isCollectionAttribute: #bodyCondition inClass: OPUMLOperation).
	self deny: (reader isCollectionAttribute: #specification inClass: OPUMLConstraint)