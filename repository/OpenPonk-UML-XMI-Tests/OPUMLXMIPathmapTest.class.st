"
Unit tests verifying pathmap registration, custom retrieval blocks, and default OMG UML specification mappings.
"
Class {
	#name : 'OPUMLXMIPathmapTest',
	#superclass : 'TestCase',
	#instVars : [
		'pathmap'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Utility',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Utility'
}

{ #category : 'running' }
OPUMLXMIPathmapTest >> setUp [

	super setUp.
	pathmap := OPUMLXMIPathmap new
]

{ #category : 'tests' }
OPUMLXMIPathmapTest >> testAddLoadsFromSpecsStorage [

	| uri |
	uri := 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi'.
	pathmap add: uri.
	self assert: (pathmap mapping includesKey: uri) description: 'Pathmap must include added specification URI'.
	self denyEmpty: (pathmap mapping at: uri)
]

{ #category : 'tests' }
OPUMLXMIPathmapTest >> testAddRetrieveUsingStoresEvaluatedValue [

	pathmap add: 'http://www.example.com/Test.xmi' retrieveUsing: [ '<xmi/>' ].
	self assert: (pathmap mapping at: 'http://www.example.com/Test.xmi') equals: '<xmi/>'
]

{ #category : 'tests' }
OPUMLXMIPathmapTest >> testDefaultRegistersPrimitiveTypesAndUmlSpecs [

	| defaultPathmap |
	defaultPathmap := OPUMLXMIPathmap default.
	self
		assert: defaultPathmap mapping keys asArray
		equals: #( 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi' 'http://www.omg.org/spec/UML/20131001/UML.xmi' ).
	self denyEmpty: (defaultPathmap mapping at: 'http://www.omg.org/spec/UML/20131001/UML.xmi')
]

{ #category : 'tests' }
OPUMLXMIPathmapTest >> testInitializeCreatesEmptyMapping [

	self assert: pathmap mapping class identicalTo: OrderedDictionary.
	self assertEmpty: pathmap mapping
]
