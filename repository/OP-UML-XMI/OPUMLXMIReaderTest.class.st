Class {
	#name : #OPUMLXMIReaderTest,
	#superclass : #TestCase,
	#instVars : [
		'reader',
		'packagedElementProperty'
	],
	#category : 'OP-UML-XMI-Tests'
}

{ #category : #'instance creation' }
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

{ #category : #'instance creation' }
OPUMLXMIReaderTest >> attributeWithHrefType [
	^ OPXMIReader
		readFrom:
			'<ownedAttribute xmi:type="uml:Property" xmi:id="Formal-base_Association" name="base_Association">
	<type xmi:type="uml:Class" href="http://www.omg.org/spec/UML/20131001/UML.xmi#Association" />
</ownedAttribute>'
]

{ #category : #'instance creation' }
OPUMLXMIReaderTest >> attributeWithPrimitiveType [
	^ OPXMIReader
		readFrom:
			'<ownedAttribute xmi:type="uml:Property" xmi:id="-attribute" name="attribute">
   <type xmi:type="uml:PrimitiveType" href="http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi#Boolean" />
</ownedAttribute>'
]

{ #category : #'instance creation' }
OPUMLXMIReaderTest >> defaultValueElement [
	^ OPXMIObjectElement new
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:LiteralInteger'.
			OPXMIValueAttribute xmiName: 'xmi:id' value: 'lowerValue'}
]

{ #category : #'instance creation' }
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

{ #category : #'instance creation' }
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

{ #category : #accessing }
OPUMLXMIReaderTest >> metaClassNamed: aName [
	^ OPUMLXMISpecsStorage metaClassNamed: aName
]

{ #category : #'instance creation' }
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

{ #category : #'instance creation' }
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

{ #category : #'instance creation' }
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

{ #category : #accessing }
OPUMLXMIReaderTest >> primitiveTypeNamed: aName [
	^ OPUMLXMISpecsStorage primitiveTypeNamed: aName
]

{ #category : #running }
OPUMLXMIReaderTest >> property: aPropertyName in: aContainerClass [
	^ (OPUMLXMISpecsStorage metaClassFor: aContainerClass) ownedAttributes
		detect: [ :each | each name = aPropertyName ]
]

{ #category : #running }
OPUMLXMIReaderTest >> setUp [
	reader := OPUMLXMIReader new.
	packagedElementProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLPackage new)
		ownedAttributes detect: [ :each | each name = 'packagedElement' ]
]

{ #category : #tests }
OPUMLXMIReaderTest >> testAmbiguousPackageImport [
	"xmi:id of <packageImport> elements are not valid and should be ignored (they are not unique). Test that we can load correctly despite that"

	| masterPkg activitiesPkg classificationPkg |
	masterPkg := reader readItem: self packageImportPackage property: packagedElementProperty.
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
]

{ #category : #tests }
OPUMLXMIReaderTest >> testAssociation [
	| result |
	result := reader readItem: self association property: packagedElementProperty.
	self assert: result umlClassName equals: #Association.
	self assert: result memberEnds size equals: 2.
	self
		assert: (result memberEnds collect: #name) asArray sorted
		equals: #('annotatedElement' 'comment') sorted.
	self assert: (result ownedEnds collect: #name) asArray equals: #('comment').
	self assert: (result memberEnds includes: result ownedEnds first)
]

{ #category : #'tests - reading - value' }
OPUMLXMIReaderTest >> testBooleanStringValue [
	| result stringProperty |
	stringProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'name' ].
	result := reader valueFor: 'true' property: stringProperty.
	self assert: result equals: 'true'
]

{ #category : #'tests - reading - value' }
OPUMLXMIReaderTest >> testBooleanValue [
	| result booleanProperty |
	booleanProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) ownedAttributes
		detect: [ :each | each name = 'isDerived' ].
	result := reader valueFor: 'true' property: booleanProperty.
	self assert: result equals: true
]

{ #category : #tests }
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

{ #category : #tests }
OPUMLXMIReaderTest >> testCreateNewInstanceXmiId [
	| item |
	item := OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems: {OPXMIValueElement xmiName: 'xmi:id' value: 'CustomId'}.
	self
		assert: (reader createNewInstanceFor: item property: packagedElementProperty) uuid
		equals: 'CustomId'
]

{ #category : #tests }
OPUMLXMIReaderTest >> testCreateNewInstanceXmiName [
	| item |
	item := OPXMIObjectElement new
		xmiName: 'Package';
		containedItems: {}.
	self
		assert: (reader createNewInstanceFor: item property: nil) umlClassName
		equals: #Package
]

{ #category : #tests }
OPUMLXMIReaderTest >> testCreateNewInstanceXmiType [
	| item |
	item := OPXMIObjectElement new
		xmiName: 'packagedElement';
		containedItems: {OPXMIValueElement xmiName: 'xmi:type' value: 'uml:Class'}.
	self
		assert: (reader createNewInstanceFor: item property: packagedElementProperty) umlClassName
		equals: #Class
]

{ #category : #tests }
OPUMLXMIReaderTest >> testGeneralizationElement [
	| result |
	result := reader
		readItem: self generalizationElement
		property: (self property: #generalization in: OPUMLClassifier new).
	self assert: result umlClassName equals: 'Generalization'.
	self assert: result general name equals: 'Element'
]

{ #category : #tests }
OPUMLXMIReaderTest >> testGroupedChildren [
	| result |
	result := reader groupedChildrenIn: self multipleNestedAttributes.
	self assert: result keys sorted equals: #(name ownedAttribute).
	self assert: (result at: #name) size equals: 1.
	self assert: (result at: #ownedAttribute) size equals: 2
]

{ #category : #tests }
OPUMLXMIReaderTest >> testInstance [
	| element result1 result2 |
	element := OPXMIObjectElement new
		xmiName: 'Package';
		containedItems: {OPXMIValueElement xmiName: 'xmi:id' value: 'CLS'}.
	result1 := reader instanceFor: element property: nil.
	self assert: result1 umlClassName equals: #Package.
	result2 := reader instanceFor: element property: nil.
	self assert: result1 == result2 description: 'We expect the same object.'
]

{ #category : #'tests - reading - value' }
OPUMLXMIReaderTest >> testIntegerStringValue [
	| result stringProperty |
	stringProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'name' ].
	result := reader valueFor: '123' property: stringProperty.
	self assert: result equals: '123'
]

{ #category : #'tests - reading - value' }
OPUMLXMIReaderTest >> testIntegerValue [
	| result integerProperty |
	integerProperty := (OPUMLXMISpecsStorage metaClassFor: OPUMLProperty new) allAttributes
		detect: [ :each | each name = 'lower' ].
	result := reader valueFor: '123' property: integerProperty.
	self assert: result equals: 123
]

{ #category : #tests }
OPUMLXMIReaderTest >> testMultipleNestedAttributes [
	| result |
	result := reader readItem: self multipleNestedAttributes property: packagedElementProperty.
	self assert: result umlClassName equals: #Class.
	self assert: result ownedAttributes size equals: 2.
	self assert: result ownedAttributes first name equals: 'annotatedElement'.
	self assert: result ownedAttributes second name equals: 'body'
]

{ #category : #tests }
OPUMLXMIReaderTest >> testNestedComplexElement [
	| result |
	result := reader
		readItem: self nestedComplexElement
		property: (self property: 'ownedAttribute' in: OPUMLClass new).
	self assert: result umlClassName equals: #Property.
	self assert: result upperValue value equals: '*'.
	"	self assert: result lowerValue value equals: 0."
	self assert: result lowerValue value equals: nil
]

{ #category : #tests }
OPUMLXMIReaderTest >> testReadBoolean [
	| result |
	result := reader
		readItem: (OPXMIValueAttribute xmiName: 'isDerived' value: 'true')
		property: (self property: #isDerived in: OPUMLProperty new).
	self assert: result equals: true
]

{ #category : #tests }
OPUMLXMIReaderTest >> testReadImportedType [
	| result property |
	property := (self metaClassNamed: #Class) allAttributes
		detect: [ :each | each name = 'ownedAttribute' ].
	result := reader readItem: self attributeWithHrefType property: property.
	self assert: result type equals: (self metaClassNamed: #Association)
]

{ #category : #tests }
OPUMLXMIReaderTest >> testReadPrimitiveType [
	| result property |
	property := (self metaClassNamed: #Class) allAttributes
		detect: [ :each | each name = 'ownedAttribute' ].
	result := reader readItem: self attributeWithPrimitiveType property: property.
	self assert: result type equals: (self primitiveTypeNamed: #Boolean)
]

{ #category : #tests }
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

{ #category : #tests }
OPUMLXMIReaderTest >> testReadTrivialXmi [
	| result |
	result := reader readXmi: self trivialXmi.
	self assert: result size equals: 1.
	self assert: result first umlClassName equals: #Package
]

{ #category : #tests }
OPUMLXMIReaderTest >> testReadTrivialishXmi [
	| result |
	result := reader readXmi: self trivialishXmi.
	self assert: result size equals: 1.
	self assert: result first umlClassName equals: #Package.
	self assert: result first packagedElements size equals: 1.
	self assert: result first packagedElements first name equals: 'Activities'
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #'instance creation' }
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

{ #category : #'instance creation' }
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
