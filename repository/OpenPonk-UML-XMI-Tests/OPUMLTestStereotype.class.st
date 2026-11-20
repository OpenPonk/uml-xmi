"
Test double representing an applied UML stereotype instance with configurable metadata, identifier, and sample tagged value for XMI reader and writer tests.
"
Class {
	#name : 'OPUMLTestStereotype',
	#superclass : 'Object',
	#instVars : [
		'umlMetaClass',
		'uuid',
		'reviewed'
	],
	#classInstVars : [
		'defaultUmlMetaClass'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Utility',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Utility'
}

{ #category : 'accessing' }
OPUMLTestStereotype class >> defaultUmlMetaClass [

	^ defaultUmlMetaClass
]

{ #category : 'accessing' }
OPUMLTestStereotype class >> defaultUmlMetaClass: anOPUMLStereotype [

	defaultUmlMetaClass := anOPUMLStereotype
]

{ #category : 'reflective operations' }
OPUMLTestStereotype >> doesNotUnderstand: aMessage [
	^ nil
]

{ #category : 'accessing' }
OPUMLTestStereotype >> oclIsKindOf: aTypeName [

	^ self oclIsTypeOf: aTypeName
]

{ #category : 'accessing' }
OPUMLTestStereotype >> oclIsTypeOf: aTypeName [

	^ aTypeName = self umlClassName
]

{ #category : 'accessing' }
OPUMLTestStereotype >> reviewed [

	^ reviewed
]

{ #category : 'accessing' }
OPUMLTestStereotype >> reviewed: aBoolean [

	reviewed := aBoolean
]

{ #category : 'accessing' }
OPUMLTestStereotype >> umlClassName [

	^ self umlMetaClass ifNotNil: [ :metaClass | metaClass name asSymbol ]
]

{ #category : 'accessing' }
OPUMLTestStereotype >> umlMetaClass [

	^ umlMetaClass ifNil: [ self class defaultUmlMetaClass ]
]

{ #category : 'accessing' }
OPUMLTestStereotype >> umlMetaClass: anOPUMLStereotype [
	umlMetaClass := anOPUMLStereotype
]

{ #category : 'accessing' }
OPUMLTestStereotype >> uuid [
	^ uuid ifNil: [ uuid := 'testStereotypeInstanceId' ]
]

{ #category : 'accessing' }
OPUMLTestStereotype >> uuid: aString [
	uuid := aString
]
