Class {
	#name : 'OPUMLTestStereotype',
	#superclass : 'Object',
	#instVars : [
		'umlMetaClass',
		'uuid'
	],
	#category : 'OpenPonk-UML-XMI-Tests',
	#package : 'OpenPonk-UML-XMI',
	#tag : 'Tests'
}

{ #category : 'reflective operations' }
OPUMLTestStereotype >> doesNotUnderstand: aMessage [
	^ nil
]

{ #category : 'accessing' }
OPUMLTestStereotype >> umlMetaClass [
	^ umlMetaClass
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
