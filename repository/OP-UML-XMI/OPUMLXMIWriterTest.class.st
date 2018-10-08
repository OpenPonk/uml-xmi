Class {
	#name : #OPUMLXMIWriterTest,
	#superclass : #TestCase,
	#instVars : [
		'writer'
	],
	#category : 'OP-UML-XMI-Tests'
}

{ #category : #'instance creation' }
OPUMLXMIWriterTest >> createTestProfile [
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
]

{ #category : #support }
OPUMLXMIWriterTest >> newStereotype: aName to: aBaseClass [
	| stereotype baseName extension baseProperty extensionProperty |
	baseName := aBaseClass name.
	stereotype := OPUMLStereotype new name: aName.
	stereotype uuid: stereotype name.
	extension := OPUMLExtension new name: baseName , '_' , aName.
	extension uuid: extension name.
	(baseProperty := OPUMLProperty new)
		name: 'base_' , baseName;
		uuid: stereotype uuid , '-' , baseProperty name;
		owningClass: stereotype;
		type: aBaseClass.
	(extensionProperty := OPUMLProperty new)
		name: 'extension_' , stereotype name;
		uuid: extension uuid , '-' , extensionProperty name;
		owningAssociation: extension;
		aggregation: OPUMLAggregationKind composite;
		type: stereotype.
	extension
		memberEnds:
			{baseProperty.
			extensionProperty}.
	extension ownedEnd: extensionProperty.
	extensionProperty
		lowerValue:
			(OPUMLLiteralInteger new
				value: 0;
				uuid: extensionProperty uuid , '-_lowerValue').
	^ {stereotype.
	extension}
]

{ #category : #running }
OPUMLXMIWriterTest >> setUp [
	super setUp.
	writer := OPUMLXMIWriter new.
	writer classPrefix: 'OPUML'
]

{ #category : #tests }
OPUMLXMIWriterTest >> testClassPrefix [
	self assert: writer classPrefix equals: 'OPUML'
]

{ #category : #'tests - stereotypes' }
OPUMLXMIWriterTest >> testElementWithStereotype [
	| result element package profile issueTag |
	self skip: 'I can''t test this without Profiles being loaded.'.
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
]

{ #category : #'tests - stereotypes' }
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

{ #category : #tests }
OPUMLXMIWriterTest >> testWriteEnumerationProperty [
	| element property result |
	element := OPUMLPackageableElement new.
	element visibility: OPUMLVisibilityKind private.
	property := element umlMetaClass allAttributes
		detect: [ :each | each name = 'visibility' ].
	result := writer writeEnumerationProperty: property value: element visibility of: element.
	self assert: result equals: {OPXMIValueAttribute xmiName: 'visibility' value: 'private'}
]

{ #category : #tests }
OPUMLXMIWriterTest >> testWriteEnumerationPropertyDefaultValue [
	| element property result |
	element := OPUMLPackageableElement new.
	property := element umlMetaClass allAttributes
		detect: [ :each | each name = 'visibility' ].
	result := writer writeEnumerationProperty: property value: element visibility of: element.
	self assert: result equals: #()
]

{ #category : #tests }
OPUMLXMIWriterTest >> testWriteEnumerationPropertyNoDefault [
  | element property result |
  element := OPUMLNamedElement new.
  element visibility: OPUMLVisibilityKind private.
  property := element umlMetaClass allAttributes
    detect: [ :each | each name = 'visibility' ].
  result := writer writeEnumerationProperty: property value: element visibility of: element.
  self assert: result equals: {OPXMIValueAttribute xmiName: 'visibility' value: 'private'}
]

{ #category : #tests }
OPUMLXMIWriterTest >> testWriteMetamodelTypeProperty [
	| element property result comment commentXmi |
	comment := OPUMLXMISpecsStorage metaClassNamed: #Comment.
	element := OPUMLProperty new.
	element type: comment.
	commentXmi := writer writeElement: comment.
	self assert: commentXmi equals: #().
	property := element umlMetaClass allAttributes detect: [ :each | each name = 'type' ].
	result := writer writeTypeProperty: property value: comment of: element.
	writer resolveReferences.
	self assert: result first referencedElement equals: nil
]

{ #category : #tests }
OPUMLXMIWriterTest >> testWriteTypeProperty [
	| element property result comment commentXmi |
	comment := OPUMLClass new name: 'Comment'.
	element := OPUMLProperty new.
	element type: comment.
	commentXmi := writer writeElement: comment.
	property := element umlMetaClass allAttributes detect: [ :each | each name = 'type' ].
	result := writer writeTypeProperty: property value: comment of: element.
	writer resolveReferences.
	self assert: result first referencedElement equals: commentXmi
]
