instance creation
createTestProfile
	| profile elementMetaclass associationMetaclass issueTag importedPackage packageImport |
	profile := OPUMLProfile new
		name: 'TestProfile';
		uuid: 'id0';
		URI: 'http://www.example.com/TestProfile'.
	importedPackage := OPUMLXMISpecsStorage umlMetamodel.
	packageImport := OPUMLPackageImport new uuid: '_packageImport.0'; importedPackage: importedPackage.
	profile packageImports add: packageImport.
	profile metamodelReferences add: packageImport.
	elementMetaclass := OPUMLClass new name: 'Element'.
	profile packagedElements addAll: (self newStereotype: #IssueTag to: elementMetaclass).
	issueTag := profile packagedElements detect: [ :e | e name = #IssueTag ].
	issueTag profile: profile.
	OPUMLProperty new
		name: 'reviewed';
		uuid: issueTag uuid , '-reviewed';
		owningClass: issueTag;
		type: (OPUMLPrimitiveType new name: 'Boolean');
		defaultValue:
			(OPUMLLiteralBoolean new
				value: false;
				uuid: issueTag uuid , '-reviewed-_defaultValue').
	associationMetaclass := OPUMLClass new name: 'Association'.
	^ profile