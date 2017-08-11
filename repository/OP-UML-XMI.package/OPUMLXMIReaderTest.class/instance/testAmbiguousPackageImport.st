tests
testAmbiguousPackageImport
	"xmi:id of <packageImport> elements are not valid and should be ignored (they are not unique). Test that we can load correctly despite that"

	| masterPkg activitiesPkg classificationPkg |
	masterPkg := reader readItem: self packageImportPackage.
	self assert: masterPkg name equals: 'UML'.
	self assert: masterPkg packageImports size equals: 2.
	activitiesPkg := masterPkg packageImports first importedPackage.
	classificationPkg := masterPkg packageImports second importedPackage.
	self assert: classificationPkg name equals: 'Classification'.
	self assert: classificationPkg packageImports asArray equals: #().
	self assert: activitiesPkg name equals: 'Activities'.
	self
		assert: activitiesPkg packageImports first importedPackage
		equals: classificationPkg