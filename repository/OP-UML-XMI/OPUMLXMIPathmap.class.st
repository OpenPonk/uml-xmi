Class {
	#name : 'OPUMLXMIPathmap',
	#superclass : 'Object',
	#instVars : [
		'mapping'
	],
	#category : 'OP-UML-XMI-Utility',
	#package : 'OP-UML-XMI',
	#tag : 'Utility'
}

{ #category : 'accessing' }
OPUMLXMIPathmap class >> default [
	^ self new
		add: 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi';
		add: 'http://www.omg.org/spec/UML/20131001/UML.xmi';
		yourself
]

{ #category : 'adding' }
OPUMLXMIPathmap >> add: aPath [
	self add: aPath retrieveUsing: [ OPUMLXMISpecsStorage current at: aPath ]
]

{ #category : 'adding' }
OPUMLXMIPathmap >> add: aPath retrieveUsing: aBlock [
	mapping at: aPath put: aBlock value
]

{ #category : 'initialization' }
OPUMLXMIPathmap >> initialize [
	super initialize.
	mapping := OrderedDictionary new
]

{ #category : 'accessing' }
OPUMLXMIPathmap >> mapping [
	^ mapping
]
