"
Test subclass of a UML stereotype definition supplying an explicit implementation class for standalone XMI reader tests without external profile extensions.
"
Class {
	#name : 'OPUMLTestStereotypeDefinition',
	#superclass : 'OPUMLStereotype',
	#instVars : [
		'implementationClass'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Utility',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Utility'
}

{ #category : 'accessing' }
OPUMLTestStereotypeDefinition >> implementationClass [

	^ implementationClass
]

{ #category : 'accessing' }
OPUMLTestStereotypeDefinition >> implementationClass: aClass [

	implementationClass := aClass
]

{ #category : 'accessing' }
OPUMLTestStereotypeDefinition >> umlClassName [

	^ #Stereotype
]
