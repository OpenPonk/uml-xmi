"
I am a unit test class verifying the deserialization of UML XMI documents. I test element instantiation, cross-reference resolution, primitive types, and generalization processing.
"
Class {
	#name : 'OPUMLXMIReaderTest',
	#superclass : 'TestCase',
	#instVars : [
		'reader',
		'packagedElementProperty'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Reader',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Reader'
}

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> association [
	| assoc ownedAttr ownedEnd |
	ownedAttr := OPXMIObjectElement new.
	ownedEnd := OPXMIObjectElement new.
	assoc := OPXMIObjectElement new.
	assoc
		xmiName: 'packagedElement';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Association'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'A_annotatedElement_comment'.
			OPXMIValueAttribute xmiName: 'name' value: 'A_annotatedElement_comment'.
			OPXMIReferenceAttribute
				xmiName: 'memberEnd'
				referencedElements:
					{ownedAttr.
					ownedEnd}.
			ownedEnd}.
	ownedAttr
		xmiName: 'ownedAttribute';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Property'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'Comment-annotatedElement'.
			OPXMIValueAttribute xmiName: 'name' value: 'annotatedElement'.
			OPXMIReferenceAttribute xmiName: 'association' referencedElements: {assoc}}.
	ownedEnd
		xmiName: 'ownedEnd';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Property'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'A_annotatedElement_comment-comment'.
			OPXMIValueAttribute xmiName: 'name' value: 'comment'.
			OPXMIReferenceAttribute xmiName: 'association' referencedElements: {assoc}}.
	^ assoc
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> attributeWithHrefType [
	^ OPXMIReader
		readFrom:
			'<ownedAttribute xmi:type="uml:Property" xmi:id="Formal-base_Association" name="base_Association">
	<type xmi:type="uml:Class" href="http://www.omg.org/spec/UML/20131001/UML.xmi#Association" />
</ownedAttribute>'
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> attributeWithPrimitiveType [
	^ OPXMIReader
		readFrom:
			'<ownedAttribute xmi:type="uml:Property" xmi:id="-attribute" name="attribute">
   <type xmi:type="uml:PrimitiveType" href="http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi#Boolean" />
</ownedAttribute>'
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> elementWithGeneralization [
	"Comment -> Element"

	^ OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Class'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'Comment'.
			OPXMIValueAttribute xmiName: 'name' value: 'Comment'.
			OPXMIObjectElement new
				xmiName: 'generalization';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Generalization'.
					OPXMIValueAttribute xmiName: 'xmi:id' value: 'Comment-_generalization.0'.
					OPXMIReferenceAttribute new
						xmiName: 'general';
						referencedElements:
							{OPXMIObjectElement new
								xmiName: 'packagedElement';
								containedItems:
									{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Class'.
									OPXMIValueAttribute xmiName: 'xmi:id' value: 'Element'.
									OPXMIValueAttribute xmiName: 'name' value: 'Element'}}}}
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> generalizationElement [
	"-> Element"

	^ OPXMIObjectElement new
		xmiName: 'generalization';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Generalization'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'Comment-_generalization.0'.
			OPXMIReferenceAttribute new
				xmiName: 'general';
				referencedElements:
					{OPXMIObjectElement new
						xmiName: 'packagedElement';
						containedItems:
							{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Class'.
							OPXMIValueAttribute xmiName: 'xmi:id' value: 'Element'.
							OPXMIValueAttribute xmiName: 'name' value: 'Element'}}}
]

{ #category : 'accessing' }
OPUMLXMIReaderTest >> metaClassNamed: aName [
	^ OPUMLXMISpecsStorage metaClassNamed: aName
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> multipleNestedAttributes [
	^ OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Class'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'Comment'.
			OPXMIValueAttribute xmiName: 'name' value: 'Comment'.
			OPXMIObjectElement new
				xmiName: 'ownedAttribute';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Property'.
					OPXMIValueAttribute xmiName: 'xmi:id' value: 'Comment-annotatedElement'.
					OPXMIValueElement xmiName: 'name' value: 'annotatedElement'}.
			OPXMIObjectElement new
				xmiName: 'ownedAttribute';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Property'.
					OPXMIValueAttribute xmiName: 'xmi:id' value: 'Comment-body'.
					OPXMIValueElement xmiName: 'name' value: 'body'}}
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> nestedComplexElement [
	^ OPXMIObjectElement new
		xmiName: 'Attribute';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Property'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'PROPID'.
			OPXMIObjectElement new
				xmiName: 'upperValue';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:LiteralUnlimitedNatural'.
					OPXMIValueAttribute xmiName: 'xmi:id' value: 'PROPID_upperValue'.
					OPXMIValueElement xmiName: 'value' value: '*'}}
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> packageImportPackage [
	| activities classification |
	classification := OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Package'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'Classification'.
			OPXMIValueAttribute xmiName: 'name' value: 'Classification'}.
	activities := OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Package'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'Activities'.
			OPXMIValueAttribute xmiName: 'name' value: 'Activities'.
			OPXMIObjectElement new
				xmiName: 'packageImport';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:PackageImport'.
					OPXMIValueAttribute xmiName: 'xmi:id' value: '_packageImport.1'.
					OPXMIReferenceAttribute xmiName: 'importedPackage' referencedElements: {classification}}}.
	^ OPXMIObjectElement new
		xmiName: 'uml:Package';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Package'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: '_0'.
			OPXMIValueAttribute xmiName: 'name' value: 'UML'.
			OPXMIObjectElement new
				xmiName: 'packageImport';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:PackageImport'.
					OPXMIValueAttribute xmiName: 'xmi:id' value: '_packageImport.1'.
					OPXMIReferenceAttribute xmiName: 'importedPackage' referencedElements: {activities}}.
			OPXMIObjectElement new
				xmiName: 'packageImport';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:PackageImport'.
					OPXMIValueAttribute xmiName: 'xmi:id' value: '_packageImport.2'.
					OPXMIReferenceAttribute xmiName: 'importedPackage' referencedElements: {classification}}}
]

{ #category : 'accessing' }
OPUMLXMIReaderTest >> primitiveTypeNamed: aName [
	^ OPUMLXMISpecsStorage primitiveTypeNamed: aName
]

{ #category : 'running' }
OPUMLXMIReaderTest >> property: aPropertyName in: aContainerClass [
	^ (OPUMLXMISpecsStorage metaClassFor: aContainerClass) ownedAttributes
		detect: [ :each | each name = aPropertyName ]
]

{ #category : 'running' }
OPUMLXMIReaderTest >> setUp [
	super setUp.
	reader := OPUMLXMIReader new.
	packagedElementProperty := self property: #packagedElement in: OPUMLPackage new
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testAmbiguousPackageImport [
	"xmi:id of <packageImport> elements are not valid and should be ignored (they are not unique). Test that we can load correctly despite that"

	| masterPkg activitiesPkg classificationPkg |
	masterPkg := reader readItem: self packageImportPackage property: packagedElementProperty.
	self assert: masterPkg name equals: 'UML'.
	self assert: masterPkg packageImports size equals: 2.
	activitiesPkg := masterPkg packageImports first importedPackage.
	classificationPkg := masterPkg packageImports second importedPackage.
	self assert: classificationPkg name equals: 'Classification'.
	self assertEmpty: classificationPkg packageImports.
	self assert: activitiesPkg name equals: 'Activities'.
	self assert: activitiesPkg packageImports first importedPackage identicalTo: classificationPkg
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testApplyStereotypesAmongstElementsAndReadTaggedValue [

	| profile stereotypeDefinition extension baseProperty extensionProperty package classElement targetClass stereotypeElement applied |
	profile := OPUMLProfile new
		           name: 'TestProfile';
		           uuid: 'prof-1';
		           URI: 'http://www.example.com/TestProfile'.
	stereotypeDefinition := OPUMLTestStereotypeDefinition new
		                        name: 'TestStereotype';
		                        uuid: 'TestStereotype';
		                        profile: profile;
		                        implementationClass: OPUMLTestStereotype;
		                        yourself.
	extension := OPUMLExtension new
		             name: 'Class_TestStereotype';
		             uuid: 'Class_TestStereotype'.
	baseProperty := OPUMLProperty new
		                name: 'base_Class';
		                uuid: 'TestStereotype-base_Class';
		                owningClass: stereotypeDefinition;
		                type: (self metaClassNamed: #Class);
		                yourself.
	extensionProperty := OPUMLProperty new
		                     name: 'extension_TestStereotype';
		                     uuid: 'Class_TestStereotype-extension_TestStereotype';
		                     owningAssociation: extension;
		                     aggregation: OPUMLAggregationKind composite;
		                     type: stereotypeDefinition;
		                     yourself.
	extension memberEnds: {
			baseProperty.
			extensionProperty }.
	extension ownedEnd: extensionProperty.
	OPUMLProperty new
		name: 'reviewed';
		uuid: 'TestStereotype-reviewed';
		owningClass: stereotypeDefinition;
		type: (self primitiveTypeNamed: #Boolean).
	profile packagedElements
		add: stereotypeDefinition;
		add: extension.
	package := OPUMLPackage new
		           name: 'Root';
		           uuid: 'pkg-1'.
	package profileApplications add: (OPUMLProfileApplication new
			 uuid: 'pa-1';
			 appliedProfile: profile).

	OPUMLTestStereotype defaultUmlMetaClass: stereotypeDefinition.
	[
		classElement := OPXMIObjectElement new
			                xmiName: 'packagedElement';
			                containedItems: {
					                (OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Class').
					                (OPXMIValueAttribute xmiName: 'xmi:id' value: 'cls-1').
					                (OPXMIValueAttribute xmiName: 'name' value: 'Person') }.
		reader classPrefix: 'OPUMLTest'.
		targetClass := reader instanceFor: classElement property: packagedElementProperty.
		reader classPrefix: 'OPUML'.
		self assert: targetClass class identicalTo: OPUMLTestClass.
		stereotypeElement := OPXMIObjectElement new
			                     xmiName: 'TestStereotype';
			                     containedItems: {
					                     (OPXMIValueAttribute xmiName: 'xmi:id' value: 'st-1').
					                     (OPXMIReferenceAttribute xmiName: 'base_Class' referencedElements: { classElement }).
					                     (OPXMIValueAttribute xmiName: 'reviewed' value: 'true') }.
		reader applyStereotypesAmongst: { stereotypeElement } to: { package }.
		self assert: targetClass appliedStereotypes size equals: 1.
		applied := targetClass appliedStereotypes first.
		self assert: applied class identicalTo: OPUMLTestStereotype.
		self assert: targetClass extension_TestStereotype identicalTo: applied.
		self assert: applied reviewed description: 'Boolean tagged value reviewed must be read as true' ] ensure: [
		OPUMLTestStereotype defaultUmlMetaClass: nil ]
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testAsPlural [

	self assert: (reader asPlural: 'class') equals: 'classes'.
	self assert: (reader asPlural: 'property') equals: 'properties'.
	self assert: (reader asPlural: 'element') equals: 'elements'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testAssociation [

	| result |
	result := reader readItem: self association property: packagedElementProperty.
	self assert: result umlClassName equals: #Association.
	self assertCollection: (result memberEnds collect: #name as: Array) hasSameElements: #( 'annotatedElement' 'comment' ).
	self assert: (result ownedEnds collect: #name as: Array) equals: #( 'comment' ).
	self assertCollection: result memberEnds includesAll: { result ownedEnds first }
]

{ #category : 'tests - reading - value' }
OPUMLXMIReaderTest >> testBooleanInvalidValueRaisesAssertionFailure [

	| booleanProperty |
	booleanProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) ownedAttributes detect: [ :each |
		                   each name = 'isDerived' ].
	self should: [ reader valueFor: 'maybe' property: booleanProperty ] raise: AssertionFailure
]

{ #category : 'tests - reading - value' }
OPUMLXMIReaderTest >> testBooleanStringValue [
	| result stringProperty |
	stringProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'name' ].
	result := reader valueFor: 'true' property: stringProperty.
	self assert: result equals: 'true'
]

{ #category : 'tests - reading - value' }
OPUMLXMIReaderTest >> testBooleanValue [

	| result booleanProperty |
	booleanProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) ownedAttributes detect: [ :each |
		                   each name = 'isDerived' ].
	result := reader valueFor: 'true' property: booleanProperty.
	self assert: result description: 'Boolean property value ''true'' must evaluate to true'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testClassPrefix [

	reader classPrefix: 'CustomPrefix'.
	self assert: reader classPrefix equals: 'CustomPrefix'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testCreateNewInstanceProperty [
	| item property |
	item := OPXMIObjectElement new
		xmiName: 'profileApplication';
		containedItems: {}.
	property := (OPUMLXMISpecsStorage metaClassFor: OPUMLPackage new) ownedAttributes
		detect: [ :each | each name = 'profileApplication' ].
	self
		assert: (reader createNewInstanceFor: item property: property) umlClassName
		equals: #ProfileApplication
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testCreateNewInstanceXmiId [
	| item |
	item := OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems: {OPXMIValueElement xmiName: 'xmi:id' value: 'CustomId'}.
	self
		assert: (reader createNewInstanceFor: item property: packagedElementProperty) uuid
		equals: 'CustomId'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testCreateNewInstanceXmiName [
	| item |
	item := OPXMIObjectElement new
		xmiName: 'Package';
		containedItems: {}.
	self
		assert: (reader createNewInstanceFor: item property: nil) umlClassName
		equals: #Package
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testCreateNewInstanceXmiType [
	| item |
	item := OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems: {OPXMIValueElement xmiName: 'xmi:type' value: 'uml:Class'}.
	self
		assert: (reader createNewInstanceFor: item property: packagedElementProperty) umlClassName
		equals: #Class
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testDefaultProfileFactoriesReturnsCollection [

	self
		assert: reader defaultProfileFactories isCollection
		description: 'Default profile factories must be returned as a collection'
]

{ #category : 'tests - reading - value' }
OPUMLXMIReaderTest >> testEnumerationValue [

	| visibilityProperty result |
	visibilityProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLNamedElement new) allAttributes detect: [ :each |
		                      each name = 'visibility' ].
	result := reader valueFor: 'private' property: visibilityProperty.
	self assert: result identicalTo: #private
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testGeneralizationElement [
	| result |
	result := reader
		readItem: self generalizationElement
		property: (self property: #generalization in: OPUMLClassifier new).
	self assert: result umlClassName equals: 'Generalization'.
	self assert: result general name equals: 'Element'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testGroupedChildren [

	| result |
	result := reader groupedChildrenIn: self multipleNestedAttributes.
	self assert: result keys sorted equals: #( name ownedAttribute ).
	self assert: ((result at: #name) collect: #value as: Array) equals: #( 'Comment' ).
	self assert: ((result at: #ownedAttribute) collect: #nameValue as: Array) equals: #( 'annotatedElement' 'body' )
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testInstance [

	| element result1 result2 |
	element := OPXMIObjectElement new
		           xmiName: 'Package';
		           containedItems: { (OPXMIValueElement xmiName: 'xmi:id' value: 'CLS') }.
	result1 := reader instanceFor: element property: nil.
	self assert: result1 umlClassName equals: #Package.
	result2 := reader instanceFor: element property: nil.
	self assert: result1 identicalTo: result2
]

{ #category : 'tests - reading - value' }
OPUMLXMIReaderTest >> testIntegerStringValue [
	| result stringProperty |
	stringProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'name' ].
	result := reader valueFor: '123' property: stringProperty.
	self assert: result equals: '123'
]

{ #category : 'tests - reading - value' }
OPUMLXMIReaderTest >> testIntegerValue [
	| result integerProperty |
	integerProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'lower' ].
	result := reader valueFor: '123' property: integerProperty.
	self assert: result equals: 123
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testMultipleNestedAttributes [

	| result |
	result := reader readItem: self multipleNestedAttributes property: packagedElementProperty.
	self assert: result umlClassName equals: #Class.
	self assert: (result ownedAttributes collect: #name as: Array) equals: #( 'annotatedElement' 'body' )
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testNestedComplexElement [

	| result |
	result := reader readItem: self nestedComplexElement property: (self property: 'ownedAttribute' in: OPUMLClass new).
	self assert: result umlClassName equals: #Property.
	self assert: result upperValue value equals: '*'.
	self assert: result lowerValue value identicalTo: nil
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadBoolean [

	| result |
	result := reader
		          readItem: (OPXMIValueAttribute xmiName: 'isDerived' value: 'true')
		          property: (self property: #isDerived in: OPUMLProperty new).
	self assert: result description: 'Reading Boolean attribute ''true'' must return true'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadFromBareRootPackage [

	| xmlString result |
	xmlString := '<uml:Package xmlns:uml="http://www.omg.org/spec/UML/20131001" xmlns:xmi="http://www.omg.org/spec/XMI/20131001" xmi:type="uml:Package" xmi:id="pkg-1" name="RootPackage"/>'.
	result := OPUMLXMIReader readFrom: xmlString readStream.
	self assert: result umlClassName equals: #Package.
	self assert: result name equals: 'RootPackage'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadImportedType [

	| result property |
	property := (self metaClassNamed: #Class) allAttributes detect: [ :each | each name = 'ownedAttribute' ].
	result := reader readItem: self attributeWithHrefType property: property.
	self assert: result type identicalTo: (self metaClassNamed: #Association)
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadMetamodelItemUnknownUriRaisesError [

	| referenceItem property |
	referenceItem := OPXMIReferenceElement new
		                 xmiName: 'type';
		                 href: 'http://www.omg.org/spec/UML/20131001/Unknown.xmi#Foo';
		                 yourself.
	property := (self metaClassNamed: #Property) allAttributes detect: [ :each | each name = 'type' ].
	self
		should: [ reader readItem: referenceItem property: property ]
		raise: Error
		withExceptionDo: [ :error |
		self assert: error messageText equals: 'Unknown type at http://www.omg.org/spec/UML/20131001/Unknown.xmi#Foo' ]
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadMofPrimitiveType [

	| item property result |
	item := OPXMIReader readFrom: '<ownedAttribute xmi:type="uml:Property" xmi:id="attr-1" name="title">
	<type xmi:type="uml:PrimitiveType" href="http://schema.omg.org/spec/MOF/20131001/PrimitiveTypes.xmi#String" />
</ownedAttribute>'.
	property := (self metaClassNamed: #Class) allAttributes detect: [ :each | each name = 'ownedAttribute' ].
	result := reader readItem: item property: property.
	self assert: result type identicalTo: (self primitiveTypeNamed: #String)
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadOldPackageWithDuplicatedGeneralizationNormalizesPackagedElements [

	| xmlString package childClass parentClass generalization |
	xmlString := '<?xml version="1.0" encoding="UTF-8"?>
<xmi:XMI xmlns:uml="http://www.omg.org/spec/UML/20110701" xmlns:xmi="http://www.omg.org/spec/XMI/20110701">
	<uml:Package xmi:type="uml:Package" xmi:id="pkg-id" name="LegacyPackage">
		<packagedElement xmi:type="uml:Class" xmi:id="child-id" name="ChildClass">
			<generalization xmi:type="uml:Generalization" xmi:id="gen-id" general="parent-id"/>
		</packagedElement>
		<packagedElement xmi:type="uml:Class" xmi:id="parent-id" name="ParentClass"/>
		<packagedElement xmi:type="uml:Generalization" xmi:id="gen-id" general="parent-id"/>
	</uml:Package>
</xmi:XMI>'.

	package := OPUMLXMIReader readFrom: xmlString readStream.
	childClass := package packagedElements detect: [ :eachElement | eachElement name = 'ChildClass' ].
	parentClass := package packagedElements detect: [ :eachElement | eachElement name = 'ParentClass' ].

	self denyEmpty: childClass generalizations.
	self assert: childClass generalizations size equals: 1.
	generalization := childClass generalizations first.
	self assert: generalization umlClassName equals: #Generalization.
	self assert: generalization general identicalTo: parentClass.
	self assertCollection: package packagedElements hasSameElements: {
			childClass.
			parentClass }
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadPrimitiveType [

	| result property |
	property := (self metaClassNamed: #Class) allAttributes detect: [ :each | each name = 'ownedAttribute' ].
	result := reader readItem: self attributeWithPrimitiveType property: property.
	self assert: result type identicalTo: (self primitiveTypeNamed: #Boolean)
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadProfileItemNotFoundWhenNoProfileFactories [

	| referenceItem property |
	reader profileFactories: #(  ).
	property := (OPUMLXMISpecsStorage metaClassFor: OPUMLProfileApplication new) allAttributes detect: [ :each |
		            each name = 'appliedProfile' ].
	referenceItem := OPXMIReferenceElement new
		                 xmiName: 'appliedProfile';
		                 href: 'http://www.example.com/MissingProfile#_0';
		                 yourself.
	self
		should: [ reader readItem: referenceItem property: property ]
		raise: Error
		withExceptionDo: [ :error |
		self assert: error messageText equals: 'No profile with URI http://www.example.com/MissingProfile found' ]
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadProfileItemWithConfiguredProfileFactory [

	| profile factory referenceItem property result |
	profile := OPUMLProfile new
		           name: 'CustomProfile';
		           URI: 'http://www.example.com/CustomProfile'.
	factory := OPUMLTestProfileFactory new
		           profile: profile;
		           matchedURIs: #( 'http://www.example.com/LegacyCustomProfile' );
		           yourself.
	reader profileFactories: { factory }.
	property := (OPUMLXMISpecsStorage metaClassFor: OPUMLProfileApplication new) allAttributes detect: [ :each |
		            each name = 'appliedProfile' ].
	referenceItem := OPXMIReferenceElement new
		                 xmiName: 'appliedProfile';
		                 href: 'http://www.example.com/LegacyCustomProfile#_0';
		                 yourself.
	result := reader readItem: referenceItem property: property.
	self assert: result identicalTo: profile
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadSimpleObject [
	| element result |
	element := OPXMIObjectElement new
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:id' value: 'Comment'.
			OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Comment'.
			OPXMIValueElement xmiName: 'body' value: 'CONTENT'}.
	result := reader readItem: element property: packagedElementProperty.
	self assert: result umlClassName equals: #Comment.
	self assert: result body equals: 'CONTENT'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadTrivialXmi [

	| result |
	result := reader readXmi: self trivialXmi.
	self assert: (result collect: #umlClassName as: Array) equals: #( #Package )
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadTrivialishXmi [

	| result |
	result := reader readXmi: self trivialishXmi.
	self assert: (result collect: #umlClassName as: Array) equals: #( #Package ).
	self assert: (result first packagedElements collect: #name as: Array) equals: #( 'Activities' )
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadWithCustomPathmap [

	| pathmap xmlString result |
	pathmap := OPUMLXMIPathmap new.
	pathmap
		add: 'http://www.example.com/External.xmi'
		retrieveUsing: [ '<xmi:XMI xmlns:uml="http://www.omg.org/spec/UML/20131001" xmlns:xmi="http://www.omg.org/spec/XMI/20131001"/>' ].
	xmlString := '<?xml version="1.0" encoding="UTF-8"?>
<xmi:XMI xmlns:uml="http://www.omg.org/spec/UML/20131001" xmlns:xmi="http://www.omg.org/spec/XMI/20131001">
	<uml:Package xmi:type="uml:Package" xmi:id="pkg-1" name="MappedPackage"/>
</xmi:XMI>'.
	result := OPUMLXMIReader read: xmlString readStream pathmap: pathmap.
	self assert: result umlClassName equals: #Package.
	self assert: result name equals: 'MappedPackage'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadWithDefaultPathmap [

	| xmlString result |
	xmlString := '<?xml version="1.0" encoding="UTF-8"?>
<xmi:XMI xmlns:uml="http://www.omg.org/spec/UML/20131001" xmlns:xmi="http://www.omg.org/spec/XMI/20131001">
	<uml:Package xmi:type="uml:Package" xmi:id="pkg-default" name="DefaultPathmapPackage"/>
</xmi:XMI>'.
	result := OPUMLXMIReader read: xmlString readStream.
	self assert: result umlClassName equals: #Package.
	self assert: result name equals: 'DefaultPathmapPackage'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReadXmiBareRootPackageReturnsCollection [

	| packageElement result |
	packageElement := OPXMIObjectElement new
		                  xmiName: 'Package';
		                  containedItems: {
				                  (OPXMIValueAttribute xmiName: 'xmi:id' value: 'pkg-1').
				                  (OPXMIValueAttribute xmiName: 'name' value: 'DirectPackage') }.
	result := reader readXmi: packageElement.
	self assert: result size equals: 1.
	self assert: result first umlClassName equals: #Package.
	self assert: result first name equals: 'DirectPackage'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testReferenceElement [
	| result gen |
	result := reader
		readItem: self elementWithGeneralization
		property: packagedElementProperty.
	self assert: result name equals: 'Comment'.
	gen := result generalizations first.
	self assert: gen umlClassName equals: #Generalization.
	self assert: gen general name equals: 'Element'
]

{ #category : 'tests' }
OPUMLXMIReaderTest >> testUniqueId [
	| regular packageImport |
	regular := OPXMIObjectElement new
		containedItems: {OPXMIValueAttribute xmiName: 'xmi:id' value: 'AAA'}.
	packageImport := OPXMIObjectElement new
		xmiName: 'packageImport';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:PackageImport'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: '_packageImport.1'.
			OPXMIReferenceAttribute xmiName: 'importedPackage' referencedElements: {regular}}.
	self assert: (reader uniqueIdOf: regular) equals: 'AAA'.
	self assert: (reader uniqueIdOf: packageImport) equals: '_packageImport.1-AAA'
]

{ #category : 'tests - reading - value' }
OPUMLXMIReaderTest >> testUnknownValueTypeRaisesError [

	| customProperty |
	customProperty := OPUMLProperty new
		                  name: 'custom';
		                  type: (OPUMLClass new name: 'CustomType');
		                  yourself.
	self
		should: [ reader valueFor: 'abc' property: customProperty ]
		raise: Error
		withExceptionDo: [ :error | self assert: error messageText equals: 'Guessed type.' ]
]

{ #category : 'tests - reading - value' }
OPUMLXMIReaderTest >> testUnlimitedNaturalNumericValue [

	| upperProperty result |
	upperProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLLiteralUnlimitedNatural new) allAttributes detect: [ :each |
		                 each name = 'value' ].
	result := reader valueFor: '5' property: upperProperty.
	self assert: result equals: 5
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> trivialXmi [
	^ OPXMIObjectElement new
		xmiName: 'XMI';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmlns:xmi' value: 'http://www.omg.org/spec/XMI/20131001'.
			OPXMIValueAttribute xmiName: 'xmlns:uml' value: 'http://www.omg.org/spec/UML/20131001'.
			OPXMIValueAttribute
				xmiName: 'xmlns:moftext'
				value: 'http://www.omg.org/spec/MOF/20131001'.
			OPXMIObjectElement new
				xmiName: 'Package';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:id' value: '_0'.
					OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Package'}.
			OPXMIObjectElement new
				xmiName: 'Tag';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:id' value: '_1'.
					OPXMIValueAttribute xmiName: 'xmi:type' value: 'mofext:Tag'}}
]

{ #category : 'instance creation' }
OPUMLXMIReaderTest >> trivialishXmi [
	^ OPXMIObjectElement new
		xmiName: 'XMI';
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmlns:xmi' value: 'http://www.omg.org/spec/XMI/20131001'.
			OPXMIValueAttribute xmiName: 'xmlns:uml' value: 'http://www.omg.org/spec/UML/20131001'.
			OPXMIValueAttribute
				xmiName: 'xmlns:moftext'
				value: 'http://www.omg.org/spec/MOF/20131001'.
			OPXMIObjectElement new
				xmiName: 'Package';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:id' value: '_0'.
					OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Package'.
					OPXMIObjectElement new
						xmiName: 'packagedElement';
						containedItems:
							{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Package'.
							OPXMIValueAttribute xmiName: 'xmi:id' value: 'Activities'.
							OPXMIValueAttribute xmiName: 'name' value: 'Activities'}}.
			OPXMIObjectElement new
				xmiName: 'Tag';
				containedItems:
					{OPXMIValueAttribute xmiName: 'xmi:id' value: '_1'.
					OPXMIValueAttribute xmiName: 'xmi:type' value: 'mofext:Tag'}}
]
