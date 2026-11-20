"
Unit tests verifying metamodel XMI deserialization, element instantiation, value parsing, and multi-valued property handling.
"
Class {
	#name : 'OPUMLXMIMetaReaderTest',
	#superclass : 'TestCase',
	#instVars : [
		'reader'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Reader',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Reader'
}

{ #category : 'running' }
OPUMLXMIMetaReaderTest >> setUp [

	super setUp.
	reader := OPUMLXMIMetaReader new
]

{ #category : 'tests' }
OPUMLXMIMetaReaderTest >> testCreateNewInstanceForRootElements [

	| packageItem modelItem profileItem |
	packageItem := OPXMIObjectElement new xmiName: 'Package'.
	modelItem := OPXMIObjectElement new xmiName: 'Model'.
	profileItem := OPXMIObjectElement new xmiName: 'Profile'.
	self assert: (reader createNewInstanceFor: packageItem property: nil) class identicalTo: OPUMLPackage.
	self assert: (reader createNewInstanceFor: modelItem property: nil) class identicalTo: OPUMLModel new class.
	self assert: (reader createNewInstanceFor: profileItem property: nil) class identicalTo: OPUMLProfile
]

{ #category : 'tests' }
OPUMLXMIMetaReaderTest >> testCreateNewInstanceForXmiType [

	| item |
	item := OPXMIObjectElement new
		        xmiName: 'packagedElement';
		        containedItems: { (OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Class') }.
	self assert: (reader createNewInstanceFor: item property: nil) umlClassName equals: #Class
]

{ #category : 'tests' }
OPUMLXMIMetaReaderTest >> testCreateNewInstanceWithoutXmiTypeRaisesError [

	| item |
	item := OPXMIObjectElement new
		        xmiName: 'packagedElement';
		        containedItems: #(  ).
	self
		should: [ reader createNewInstanceFor: item property: nil ]
		raise: Error
		withExceptionDo: [ :error | self assert: error messageText equals: 'Unknown element type.' ]
]

{ #category : 'tests' }
OPUMLXMIMetaReaderTest >> testReadItemWithSingularPluralInheritedAndReferenceProperties [

	| targetClass commentElement unresolvedRef packageElement result repeatedResult |
	targetClass := OPXMIObjectElement new
		               xmiName: 'packagedElement';
		               containedItems: {
				               (OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Class').
				               (OPXMIValueAttribute xmiName: 'xmi:id' value: 'cls-target').
				               (OPXMIValueAttribute xmiName: 'name' value: 'Target') }.
	commentElement := OPXMIObjectElement new
		                  xmiName: 'ownedComment';
		                  containedItems: {
				                  (OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:Comment').
				                  (OPXMIValueAttribute xmiName: 'xmi:id' value: 'cmt-1').
				                  (OPXMIValueAttribute xmiName: 'body' value: 'Doc').
				                  (OPXMIReferenceAttribute xmiName: 'annotatedElement' referencedElements: { targetClass }) }.
	unresolvedRef := OPXMIReferenceAttribute xmiName: 'URI' referencedElements: #(  ).
	packageElement := OPXMIObjectElement new
		                  xmiName: 'Package';
		                  containedItems: {
				                  (OPXMIValueAttribute xmiName: 'xmi:id' value: 'pkg-1').
				                  (OPXMIValueAttribute xmiName: 'name' value: 'MetaPkg').
				                  unresolvedRef.
				                  targetClass.
				                  commentElement }.
	result := reader readItem: packageElement property: nil.
	repeatedResult := reader readItem: packageElement property: nil.
	self assert: repeatedResult identicalTo: result.
	self assert: result name equals: 'MetaPkg'.
	self assert: result URI identicalTo: nil.
	self assert: (result packagedElements collect: #name as: Array) equals: #( 'Target' ).
	self assert: result ownedComments size equals: 1.
	self assert: result ownedComments first body equals: 'Doc'.
	self assert: result ownedComments first annotatedElements first identicalTo: result packagedElements first
]

{ #category : 'tests' }
OPUMLXMIMetaReaderTest >> testValueForBooleanNumberAndString [

	self assert: (reader valueFor: 'true') description: 'Meta reader must parse ''true'' as true'.
	self deny: (reader valueFor: 'false') description: 'Meta reader must parse ''false'' as false'.
	self assert: (reader valueFor: '42') equals: 42.
	self assert: (reader valueFor: 'Class') equals: 'Class'
]
