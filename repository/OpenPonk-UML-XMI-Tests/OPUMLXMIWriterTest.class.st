"
I am a unit test class verifying the serialization of OpenPonk UML models into XMI documents. I test property formatting, reference handling, and the serialization of applied profiles.
"
Class {
	#name : 'OPUMLXMIWriterTest',
	#superclass : 'TestCase',
	#instVars : [
		'writer'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Writer',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Writer'
}

{ #category : 'helpers' }
OPUMLXMIWriterTest >> createClassStereotype [
	| profile classMetaclass stereotypePair stereotype |
	profile := OPUMLProfile new
		name: 'TestProfile';
		uuid: 'profileId';
		URI: 'http://www.example.com/TestProfile'.
	classMetaclass := OPUMLClass new name: 'Class'.
	stereotypePair := self newStereotype: #TestStereotype to: classMetaclass.
	profile packagedElements addAll: stereotypePair.
	stereotype := stereotypePair first.
	stereotype profile: profile.
	^ stereotype
]

{ #category : 'support' }
OPUMLXMIWriterTest >> newStereotype: aName to: aBaseClass [

	| stereotype baseName extension baseProperty extensionProperty |
	baseName := aBaseClass name.
	stereotype := OPUMLStereotype new name: aName.
	stereotype uuid: stereotype name.
	extension := OPUMLExtension new name: (String streamContents: [ :stream |
				              stream << baseName.
				              stream << '_'.
				              stream << aName ]).
	extension uuid: extension name.
	(baseProperty := OPUMLProperty new)
		name: 'base_' , baseName;
		uuid: (String streamContents: [ :stream |
						 stream << stereotype uuid.
						 stream << '-'.
						 stream << baseProperty name ]);
		owningClass: stereotype;
		type: aBaseClass.
	(extensionProperty := OPUMLProperty new)
		name: 'extension_' , stereotype name;
		uuid: (String streamContents: [ :stream |
						 stream << extension uuid.
						 stream << '-'.
						 stream << extensionProperty name ]);
		owningAssociation: extension;
		aggregation: OPUMLAggregationKind composite;
		type: stereotype.
	extension memberEnds: {
			baseProperty.
			extensionProperty }.
	extension ownedEnd: extensionProperty.
	extensionProperty lowerValue: (OPUMLLiteralInteger new
			 value: 0;
			 uuid: extensionProperty uuid , '-_lowerValue').
	^ {
		  stereotype.
		  extension }
]

{ #category : 'running' }
OPUMLXMIWriterTest >> setUp [
	super setUp.
	writer := OPUMLXMIWriter new.
	writer classPrefix: 'OPUML'
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testAccessorNameForClassProperty [

	| classProperty |
	classProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes detect: [ :each | each name = 'class' ].
	self assert: (writer accessorNameFor: classProperty) equals: 'owningClass'
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testClassPrefix [
	self assert: writer classPrefix equals: 'OPUML'
]

{ #category : 'tests - stereotypes' }
OPUMLXMIWriterTest >> testCollectProfilesFromNestedElementsCycleAndNonElement [

	| profile package nestedClass visited profiles |
	profile := OPUMLProfile new
		           name: 'NestedProfile';
		           uuid: 'profileId';
		           URI: 'http://www.example.com/NestedProfile'.
	package := OPUMLPackage new
		           name: 'Root';
		           uuid: 'rootId'.
	nestedClass := OPUMLClass new
		               name: 'Child';
		               uuid: 'childId'.
	package packagedElements add: nestedClass.
	package profileApplications add: (OPUMLProfileApplication new
			 uuid: 'appId';
			 appliedProfile: profile).
	profiles := Set new.
	visited := IdentitySet new.
	writer collectProfilesFrom: package into: profiles visited: visited.
	writer collectProfilesFrom: package into: profiles visited: visited.
	writer collectProfilesFrom: OPUMLTestStereotype new into: profiles visited: visited.
	self assertCollection: profiles hasSameElements: { profile }
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testToStringAndReadRoundtrip [

	| package classElement xmlString restoredPackage |
	package := OPUMLPackage new
		           name: 'DemoPackage';
		           uuid: 'pkg-1'.
	classElement := OPUMLClass new
		                name: 'Person';
		                uuid: 'cls-1'.
	package packagedElements add: classElement.

	xmlString := OPUMLXMIWriter toString: package.
	self assert: (xmlString includesSubstring: 'uml:Package') description: 'Serialized XMI must contain root uml:Package'.
	restoredPackage := OPUMLXMIReader readFrom: xmlString readStream.
	self assert: restoredPackage name equals: 'DemoPackage'.
	self assert: (restoredPackage packagedElements collect: #name as: Array) equals: #( 'Person' )
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testUmlUriIsUml25 [
	self assert: writer umlUri equals: 'http://www.omg.org/spec/UML/20131001'
]

{ #category : 'tests - stereotypes' }
OPUMLXMIWriterTest >> testWriteAppliedProfile [
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
]

{ #category : 'tests - stereotypes' }
OPUMLXMIWriterTest >> testWriteAppliedProfileDeclaresXmlNamespaceInRoot [

	| profile package document |
	profile := OPUMLProfile new
		           name: 'TestProfile';
		           uuid: 'profileId';
		           URI: 'http://www.example.com/TestProfile'.
	package := OPUMLPackage new
		           name: 'RootPackage';
		           uuid: 'packageId'.
	package profileApplications add: (OPUMLProfileApplication new
			 uuid: 'applicationId';
			 appliedProfile: profile).

	document := writer write: package.
	self
		assertCollection: (document containedItems select: #isAttribute)
		includesAll: { (OPXMIValueAttribute xmiName: 'xmlns:TestProfile' value: profile URI) }
]

{ #category : 'tests - stereotypes' }
OPUMLXMIWriterTest >> testWriteAppliedProfileWithUuid [

	| profile application property result expectedHref |
	profile := OPUMLProfile new
		           name: 'TestProfile';
		           URI: 'http://www.example.com/TestProfile'.
	application := OPUMLProfileApplication new
		               uuid: 'MyPackage-_profileApplication.0';
		               appliedProfile: profile.
	property := application umlMetaClass allAttributes detect: [ :each | each name = 'appliedProfile' ].
	result := writer writeNonCompositeProperty: property value: application appliedProfile of: application.
	writer resolveReferences.
	expectedHref := String streamContents: [ :stream |
			                stream << 'http://www.example.com/TestProfile#'.
			                stream << profile uuid asString ].
	self assert: result first href equals: expectedHref
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteEnumerationProperty [
	| element property result |
	element := OPUMLPackageableElement new.
	element visibility: OPUMLVisibilityKind private.
	property := element umlMetaClass allAttributes
		detect: [ :each | each name = 'visibility' ].
	result := writer writeEnumerationProperty: property value: element visibility of: element.
	self assert: result equals: {OPXMIValueAttribute xmiName: 'visibility' value: 'private'}
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteEnumerationPropertyDefaultValue [

	| element property result |
	element := OPUMLPackageableElement new.
	property := element umlMetaClass allAttributes detect: [ :each | each name = 'visibility' ].
	result := writer writeEnumerationProperty: property value: element visibility of: element.
	self assertEmpty: result
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteEnumerationPropertyNoDefault [
  | element property result |
  element := OPUMLNamedElement new.
  element visibility: OPUMLVisibilityKind private.
  property := element umlMetaClass allAttributes
    detect: [ :each | each name = 'visibility' ].
  result := writer writeEnumerationProperty: property value: element visibility of: element.
  self assert: result equals: {OPXMIValueAttribute xmiName: 'visibility' value: 'private'}
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteInternalImportedPackageReference [

	| rootPackage targetPackage packageImport document rootElement importElement importedRef |
	rootPackage := OPUMLPackage new
		               name: 'Root';
		               uuid: 'root-id'.
	targetPackage := OPUMLPackage new
		                 name: 'Target';
		                 uuid: 'target-id'.
	rootPackage packagedElements add: targetPackage.
	packageImport := OPUMLPackageImport new
		                 uuid: 'import-id';
		                 importedPackage: targetPackage.
	rootPackage packageImports add: packageImport.

	document := writer write: rootPackage.
	rootElement := document containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'uml:Package' ] ].
	importElement := rootElement containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'packageImport' ] ].
	importedRef := importElement containedItems detect: [ :each | each isReferenceItem and: [ each xmiName = 'importedPackage' ] ].
	self assert: importedRef referencedElement xmiId equals: 'target-id'
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteMetamodelTypeProperty [

	| element property result comment commentXmi |
	comment := OPUMLXMISpecsStorage metaClassNamed: #Comment.
	element := OPUMLProperty new.
	element type: comment.
	commentXmi := writer writeElement: comment.
	self assertEmpty: commentXmi.
	property := element umlMetaClass allAttributes detect: [ :each | each name = 'type' ].
	result := writer writeTypeProperty: property value: comment of: element.
	writer resolveReferences.
	self assert: result size equals: 1.
	self assert: result first referencedElement identicalTo: nil.
	self assert: result first xmiType equals: 'uml:Class'.
	self assert: result first href equals: 'http://www.omg.org/spec/UML/20131001/UML.xmi#Comment'
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteMultivaluedNonCompositeProperty [

	| package classA classB comment document packageElement commentElement annotatedAttr |
	package := OPUMLPackage new
		           name: 'Root';
		           uuid: 'root-id'.
	classA := OPUMLClass new
		          name: 'ClassA';
		          uuid: 'a-id'.
	classB := OPUMLClass new
		          name: 'ClassB';
		          uuid: 'b-id'.
	comment := OPUMLComment new
		           body: 'Note';
		           uuid: 'comment-id'.
	comment annotatedElements
		add: classA;
		add: classB.
	package packagedElements
		add: classA;
		add: classB.
	package ownedComments add: comment.

	document := writer write: package.
	packageElement := document containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'uml:Package' ] ].
	commentElement := packageElement containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'ownedComment' ] ].
	annotatedAttr := commentElement containedItems detect: [ :each | each isReferenceItem and: [ each xmiName = 'annotatedElement' ] ].
	self assertCollection: (annotatedAttr referencedElements collect: #xmiId as: Array) hasSameElements: #( 'a-id' 'b-id' )
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteMultivaluedPrimitiveProperty [

	| expression document expressionElement bodyAttributes |
	expression := OPUMLOpaqueExpression new
		              uuid: 'expr-1';
		              bodies: #( 'x > 0' 'y > 0' );
		              yourself.
	document := writer write: expression.
	expressionElement := document containedItems detect: [ :each |
		                     each isObjectElement and: [ each xmiName = 'uml:OpaqueExpression' ] ].
	bodyAttributes := expressionElement containedItems select: [ :each | each isValueItem and: [ each xmiName = 'body' ] ].
	self assert: (bodyAttributes collect: #value as: Array) equals: #( 'x > 0' 'y > 0' )
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWritePackageExcludesNonPackageableElements [

	| pkg cls1 cls2 gen xmiDoc pkgElement packagedElementItems |
	pkg := OPUMLPackage new name: 'Pkg'.
	cls1 := OPUMLClass new name: 'C1'.
	cls2 := OPUMLClass new name: 'C2'.
	gen := OPUMLGeneralization new
		       general: cls2;
		       specific: cls1.
	"Simulate a corrupted in-memory model"
	pkg packagedElements
		add: cls1;
		add: cls2;
		add: gen.

	xmiDoc := writer write: pkg.
	pkgElement := xmiDoc containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'uml:Package' ] ].
	packagedElementItems := pkgElement containedItems select: [ :each |
		                        each isObjectElement and: [ each xmiName = 'packagedElement' ] ].

	self assertCollection: (packagedElementItems collect: [ :each | each xmiType -> each nameValue ]) hasSameElements: {
			('uml:Class' -> 'C1').
			('uml:Class' -> 'C2') }
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWritePackageWithOnlyNonPackageableElementsOmitsPackagedElements [

	| package generalization document packageElement packagedItems |
	package := OPUMLPackage new
		           name: 'OnlyInvalid';
		           uuid: 'pkgId'.
	generalization := OPUMLGeneralization new uuid: 'genId'.
	package packagedElements add: generalization.

	document := writer write: package.
	packageElement := document containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'uml:Package' ] ].
	packagedItems := packageElement containedItems select: [ :each | each isObjectElement and: [ each xmiName = 'packagedElement' ] ].
	self assertEmpty: packagedItems
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWritePrimitiveTypeProperty [

	| ownerClass attribute document classElement attrElement typeElement |
	ownerClass := OPUMLClass new
		              name: 'Person';
		              uuid: 'cls-1'.
	attribute := OPUMLProperty new
		             name: 'age';
		             uuid: 'prop-1';
		             owningClass: ownerClass;
		             type: (OPUMLXMISpecsStorage primitiveTypeNamed: 'Integer');
		             yourself.
	document := writer write: ownerClass.
	classElement := document containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'uml:Class' ] ].
	attrElement := classElement containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'ownedAttribute' ] ].
	typeElement := attrElement containedItems detect: [ :each | each isReferenceItem and: [ each xmiName = 'type' ] ].
	self assert: typeElement xmiType equals: 'uml:PrimitiveType'.
	self assert: typeElement href equals: 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi#Integer'
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteProfileWithMetamodelReference [

	| profile packageImport document profileElement metamodelRefItem importElement importedRef |
	profile := OPUMLProfile new
		           name: 'TestProfile';
		           uuid: 'profile-id';
		           URI: 'http://www.example.com/TestProfile'.
	packageImport := OPUMLPackageImport new
		                 uuid: 'import-0';
		                 importedPackage: OPUMLXMISpecsStorage umlMetamodel.
	profile packageImports add: packageImport.
	profile metamodelReferences add: packageImport.

	document := writer write: profile.
	profileElement := document containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'uml:Profile' ] ].
	metamodelRefItem := profileElement containedItems detect: [ :each |
		                    each isReferenceItem and: [ each xmiName = 'metamodelReference' ] ].
	self assert: metamodelRefItem referencedElement xmiId equals: 'import-0'.
	importElement := profileElement containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'packageImport' ] ].
	importedRef := importElement containedItems detect: [ :each | each isReferenceItem and: [ each xmiName = 'importedPackage' ] ].
	self assert: importedRef href equals: (String streamContents: [ :stream |
				 stream << OPUMLXMISpecsStorage umlMetamodel URI.
				 stream << '#'.
				 stream << OPUMLXMISpecsStorage umlMetamodel uuid asString ])
]

{ #category : 'tests - stereotypes' }
OPUMLXMIWriterTest >> testWriteResetsStereotypesBetweenCalls [

	| stereotype stereotypeInstance stereotypedClass plainClass firstDocument secondDocument |
	stereotype := self createClassStereotype.
	stereotypeInstance := OPUMLTestStereotype new
		                      umlMetaClass: stereotype;
		                      uuid: 'stereotypeInstanceId'.
	stereotypedClass := OPUMLClass new
		                    name: 'Stereotyped';
		                    uuid: 'class1'.
	stereotypedClass appliedStereotypes add: stereotypeInstance.
	plainClass := OPUMLClass new
		              name: 'Plain';
		              uuid: 'class2'.

	firstDocument := writer write: stereotypedClass.
	self
		assert:
		(firstDocument containedItems count: [ :each | each isObjectElement and: [ each xmiName = 'TestProfile:TestStereotype' ] ])
		equals: 1.

	secondDocument := writer write: plainClass.
	self assertEmpty: writer resolvedStereotypes.
	self assertEmpty:
		(secondDocument containedItems select: [ :each | each isObjectElement and: [ each xmiName = 'TestProfile:TestStereotype' ] ])
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteSingleValuedCompositeProperty [

	| property literal document propertyElement lowerElement |
	property := OPUMLProperty new
		            name: 'items';
		            uuid: 'prop-1'.
	literal := OPUMLLiteralInteger new
		           value: 2;
		           uuid: 'lit-1'.
	property lowerValue: literal.

	document := writer write: property.
	propertyElement := document containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'uml:Property' ] ].
	lowerElement := propertyElement containedItems detect: [ :each | each isObjectElement and: [ each xmiName = 'lowerValue' ] ].
	self assert: lowerElement xmiType equals: 'uml:LiteralInteger'.
	self assert: (lowerElement containedItems detect: [ :each | each xmiName = 'value' ]) value equals: '2'
]

{ #category : 'tests - stereotypes' }
OPUMLXMIWriterTest >> testWriteStereotypeFallbackWhenBasePropertyTypeDoesNotMatch [

	| stereotype stereotypeInstance associationElement xmi stereotypeElements attributes |
	stereotype := self createClassStereotype.
	stereotypeInstance := OPUMLTestStereotype new
		                      umlMetaClass: stereotype;
		                      uuid: 'stereotypeInstanceId'.
	associationElement := OPUMLAssociation new
		                      name: 'TestAssociation';
		                      uuid: 'testAssocId'.
	associationElement appliedStereotypes add: stereotypeInstance.
	xmi := writer write: associationElement.
	self assert: xmi class identicalTo: OPXMIObjectElement.
	self assert: xmi xmiName equals: 'xmi:XMI'.
	stereotypeElements := xmi containedItems select: [ :eachItem |
		                      eachItem isObjectElement and: [ eachItem xmiName = 'TestProfile:TestStereotype' ] ].
	self assert: stereotypeElements size equals: 1.
	attributes := stereotypeElements first containedItems select: #isAttribute.
	self assertCollection: attributes hasSameElements: {
			(OPXMIValueAttribute xmiName: 'xmi:id' value: 'stereotypeInstanceId').
			(OPXMIValueAttribute xmiName: 'base_Class' value: 'testAssocId') }
]

{ #category : 'tests - stereotypes' }
OPUMLXMIWriterTest >> testWriteStereotypeUsesSpecificBaseAttribute [

	| stereotype stereotypeInstance classElement document stereotypeElements attributes |
	stereotype := self createClassStereotype.
	stereotypeInstance := OPUMLTestStereotype new
		                      umlMetaClass: stereotype;
		                      uuid: 'stereotypeInstanceId'.
	classElement := OPUMLClass new
		                name: 'Person';
		                uuid: 'personId'.
	classElement appliedStereotypes add: stereotypeInstance.

	document := writer write: classElement.
	stereotypeElements := document containedItems select: [ :eachItem |
		                      eachItem isObjectElement and: [ eachItem xmiName = 'TestProfile:TestStereotype' ] ].
	self assert: stereotypeElements size equals: 1.
	attributes := stereotypeElements first containedItems select: #isAttribute.
	self denyCollection: (attributes collect: #xmiName) includesAny: #( 'base_Element' ).
	self assertCollection: attributes hasSameElements: {
			(OPXMIValueAttribute xmiName: 'xmi:id' value: 'stereotypeInstanceId').
			(OPXMIValueAttribute xmiName: 'base_Class' value: 'personId') }
]

{ #category : 'tests - stereotypes' }
OPUMLXMIWriterTest >> testWriteStereotypeWithoutBasePropertyAndWithCustomTag [

	| profile stereotype stereotypeInstance classElement document stereotypeElements attributes |
	profile := OPUMLProfile new
		           name: 'CustomProfile';
		           uuid: 'profileId';
		           URI: 'http://www.example.com/CustomProfile'.
	stereotype := OPUMLStereotype new
		              name: 'TagOnly';
		              uuid: 'tagOnlyId';
		              profile: profile;
		              yourself.
	OPUMLProperty new
		name: 'reviewed';
		uuid: 'tagOnlyId-reviewed';
		owningClass: stereotype;
		type: (OPUMLXMISpecsStorage primitiveTypeNamed: 'Boolean').
	stereotypeInstance := OPUMLTestStereotype new
		                      umlMetaClass: stereotype;
		                      uuid: 'stereoInstanceId';
		                      reviewed: true;
		                      yourself.
	classElement := OPUMLClass new
		                name: 'Item';
		                uuid: 'itemId'.
	classElement appliedStereotypes add: stereotypeInstance.

	document := writer write: classElement.
	stereotypeElements := document containedItems select: [ :eachItem |
		                      eachItem isObjectElement and: [ eachItem xmiName = 'CustomProfile:TagOnly' ] ].
	self assert: stereotypeElements size equals: 1.
	attributes := stereotypeElements first containedItems select: #isAttribute.
	self assertCollection: attributes hasSameElements: {
			(OPXMIValueAttribute xmiName: 'xmi:id' value: 'stereoInstanceId').
			(OPXMIValueAttribute xmiName: 'reviewed' value: 'true') }
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteToStream [

	| package output |
	package := OPUMLPackage new
		           name: 'StreamedPackage';
		           uuid: 'pkg-stream'.
	output := String streamContents: [ :stream | OPUMLXMIWriter write: package toStream: stream ].
	self assert: (output includesSubstring: 'StreamedPackage') description: 'Stream output must include package name'
]

{ #category : 'tests' }
OPUMLXMIWriterTest >> testWriteTypeProperty [

	| element property result comment commentXmi |
	comment := OPUMLClass new name: 'Comment'.
	element := OPUMLProperty new.
	element type: comment.
	commentXmi := writer writeElement: comment.
	property := element umlMetaClass allAttributes detect: [ :each | each name = 'type' ].
	result := writer writeTypeProperty: property value: comment of: element.
	writer resolveReferences.
	self assert: result first referencedElement identicalTo: commentXmi
]
