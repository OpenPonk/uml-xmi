"
Test subclass of a UML class providing a stereotype extension slot so stereotype deserialization can be verified without external profile packages.
"
Class {
	#name : 'OPUMLTestClass',
	#superclass : 'OPUMLClass',
	#instVars : [
		'extensionTestStereotype'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Utility',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Utility'
}

{ #category : 'accessing' }
OPUMLTestClass >> extension_TestStereotype [

	^ extensionTestStereotype
]

{ #category : 'accessing' }
OPUMLTestClass >> extension_TestStereotype: aStereotype [

	extensionTestStereotype := aStereotype
]

{ #category : 'accessing' }
OPUMLTestClass >> umlClassName [

	^ #Class
]
