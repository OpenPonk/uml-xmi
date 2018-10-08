Class {
	#name : #OPUMLXMIWriter,
	#superclass : #Object,
	#instVars : [
		'classPrefix',
		'identityCache',
		'unresolved',
		'metamodelPackagedElements',
		'umlMetamodel',
		'stereotypes'
	],
	#category : 'OP-UML-XMI-Writer'
}

{ #category : #'instance creation' }
OPUMLXMIWriter class >> toString: aModel [
	^ OPXMIWriter writeToString: (self new write: aModel)
]

{ #category : #writing }
OPUMLXMIWriter >> accessorNameFor: aProperty [
	| name |
	name := aProperty name.
	name = 'class'
		ifTrue: [ name := 'owningClass' ].
	aProperty isMultivalued
		ifTrue: [ ^ self asPlural: name ].
	^ name
]

{ #category : #utility }
OPUMLXMIWriter >> asPlural: aString [
	(aString endsWith: 's')
		ifTrue: [ ^ aString , 'es' ].
	(aString endsWith: 'y')
		ifTrue: [ ^ (aString withoutSuffix: 'y') , 'ies' ].
	^ aString , 's'
]

{ #category : #utility }
OPUMLXMIWriter >> asSingular: aString [
	(aString endsWith: 'ses')
		ifTrue: [ ^ aString withoutSuffix: 'es' ].
	(aString endsWith: 'ies')
		ifTrue: [ ^ (aString withoutSuffix: 'ies') , 'y' ].
	^ aString withoutSuffix: 's'
]

{ #category : #accessing }
OPUMLXMIWriter >> classPrefix [
	^ classPrefix
]

{ #category : #accessing }
OPUMLXMIWriter >> classPrefix: anObject [
	classPrefix := anObject
]

{ #category : #accessing }
OPUMLXMIWriter >> defaultClassPrefix [
	^ 'OPUML'
]

{ #category : #writing }
OPUMLXMIWriter >> idFor: anElement [
	^ anElement uuid asString
]

{ #category : #initialization }
OPUMLXMIWriter >> initialize [
	super initialize.
	unresolved := OrderedCollection new.
	identityCache := Dictionary new.
	classPrefix := self defaultClassPrefix.
	stereotypes := OrderedCollection new.
	umlMetamodel := OPUMLXMISpecsStorage umlMetamodel
]

{ #category : #testing }
OPUMLXMIWriter >> isMetaclass: aClass [
	(aClass oclIsTypeOf: #Class)
		ifFalse: [ ^ false ].
	OPUMLXMISpecsStorage metaClassMap at: aClass name ifPresent: [ :mm | ^ mm = aClass ].
	^ false
]

{ #category : #accessing }
OPUMLXMIWriter >> metamodelUri [
	^ umlMetamodel URI , '/' , umlMetamodel name , '.xmi'
]

{ #category : #accessing }
OPUMLXMIWriter >> primitiveTypesUri [
	^ umlMetamodel URI , '/' , 'PrimitiveTypes' , '.xmi'
]

{ #category : #writing }
OPUMLXMIWriter >> processStereotype: aStereotype of: anElement [
	| element containedItems stereoMeta properties |
	element := OPXMIObjectElement new.
	containedItems := OrderedCollection new.
	element containedItems: containedItems.
	stereoMeta := aStereotype umlMetaClass.
	element xmiName: stereoMeta profile name , ':' , stereoMeta name.
	containedItems
		add: (OPXMIValueAttribute xmiName: 'xmi:id' value: (self idFor: aStereotype)).
	properties := stereoMeta ownedAttributes asArray.
	properties
		do: [ :each | containedItems addAll: (self writeProperty: each of: aStereotype) ].
	stereotypes add: element
]

{ #category : #writing }
OPUMLXMIWriter >> processStereotypesIn: anElement [
	anElement appliedStereotypes ifEmpty: [ ^ self ].
	anElement appliedStereotypes
		do: [ :stereo | self processStereotype: stereo of: anElement ]
]

{ #category : #accessing }
OPUMLXMIWriter >> propertiesOf: anElement [
	| properties |
	properties := anElement umlMetaClass allAttributes asOrderedCollection.
	"throw away properties that were redefined by another one"
	properties copy
		do:
			[ :each | each redefinedProperties do: [ :redefined | properties remove: redefined ifAbsent: [  ] ] ].
	^ properties
]

{ #category : #writing }
OPUMLXMIWriter >> referenceFor: anElement [
	^ identityCache at: anElement
]

{ #category : #writing }
OPUMLXMIWriter >> resolveReferences [
	unresolved do: #value
]

{ #category : #writing }
OPUMLXMIWriter >> resolvedStereotypes [
	^ stereotypes
]

{ #category : #writing }
OPUMLXMIWriter >> umlUri [
	^ 'http://www.omg.org/spec/UML/20110701'
]

{ #category : #writing }
OPUMLXMIWriter >> write: anElement [
	| document rootElement |
	unresolved := OrderedCollection new.
	identityCache := IdentityDictionary new.
	document := OPXMIObjectElement new.
	document xmiName: 'xmi:XMI'.
	rootElement := self writeElement: anElement.
	rootElement xmiName: 'uml:' , anElement umlMetaClass name.
	document
		containedItems:
			{OPXMIValueAttribute xmiName: 'xmlns:uml' value: 'http://www.omg.org/spec/UML/20110701'.
			OPXMIValueAttribute xmiName: 'xmlns:xmi' value: 'http://www.omg.org/spec/XMI/20110701'}
				, {rootElement} , self resolvedStereotypes.
	self resolveReferences.
	^ document
]

{ #category : #writing }
OPUMLXMIWriter >> writeCompositeProperty: aProperty value: aValue of: anElement [
	| values |
	values := aProperty isMultivalued
		ifTrue: [ values := aValue asArray ]
		ifFalse: [ values := {aValue} ].
	^ values
		collect: [ :each | 
			| el |
			el := self writeElement: each.
			el xmiName: aProperty name ]
]

{ #category : #writing }
OPUMLXMIWriter >> writeElement: anElement [
	| element containedItems properties |
	(self isMetaclass: anElement)
		ifTrue: [ ^ #() ].
	self processStereotypesIn: anElement.
	element := OPXMIObjectElement new.
	containedItems := OrderedCollection new.
	element containedItems: containedItems.
	identityCache at: anElement put: element.
	element xmiName: 'to-be-specified'.
	containedItems
		add:
			(OPXMIValueAttribute xmiName: 'xmi:type' value: 'uml:' , anElement umlMetaClass name).
	containedItems
		add: (OPXMIValueAttribute xmiName: 'xmi:id' value: (self idFor: anElement)).
	properties := self propertiesOf: anElement.
	properties := (properties collect: [ :each | each name -> each ]) asOrderedDictionary
		values.
	properties
		do: [ :each | containedItems addAll: (self writeProperty: each of: anElement) ].
	^ element
]

{ #category : #writing }
OPUMLXMIWriter >> writeEnumerationProperty: aProperty value: aValue of: anElement [
	| values |
	(aProperty defaultValue isNotNil and: [ aProperty defaultValue instance name = aValue ])
		ifTrue: [ ^ #() ].
	values := aProperty isMultivalued
		ifTrue: [ values := aValue asArray ]
		ifFalse: [ values := {aValue} ].
	^ values collect: [ :each | OPXMIValueAttribute xmiName: aProperty name value: each asString ]
]

{ #category : #writing }
OPUMLXMIWriter >> writeNonCompositeProperty: aProperty value: aValue of: anElement [
	| values referenceItem |
	(aProperty opposite isNil or: [ aProperty opposite isComposite ])
		ifTrue: [ ^ #() ].
	values := aProperty isMultivalued
		ifTrue: [ values := aValue asArray ]
		ifFalse: [ values := {aValue} ].
	(values anyOne isKindOf: OPUMLPrimitiveType)
		ifTrue: [ ^ values
				collect: [ :each | 
					(OPXMIReferenceElement xmiName: aProperty name referencedElements: {})
						xmiType: 'uml:PrimitiveType';
						href: self primitiveTypesUri, '#', each name ] ].
	(#(importedPackage appliedProfile) includes: aProperty name)
		ifTrue: [ referenceItem := OPXMIReferenceElement xmiName: aProperty name referencedElements: {}.
			unresolved
				add: [ self assert: [ aProperty isMultivalued not ].
					identityCache
						at: values anyOne
						ifPresent: [ :ref | referenceItem referencedElements: {ref} ]
						ifAbsent: [ referenceItem href: values anyOne URI , '#' , values anyOne uuid ] ].
			^ {referenceItem} ].
	referenceItem := OPXMIReferenceAttribute xmiName: aProperty name referencedElements: {}.
	unresolved
		add:
			[ referenceItem referencedElements: (values collect: [ :each | self referenceFor: each ]) ].
	^ {referenceItem}
]

{ #category : #writing }
OPUMLXMIWriter >> writePrimitiveProperty: aProperty value: aValue of: anElement [
	| values |
	(aProperty defaultValue isNotNil and: [ aProperty defaultValue value = aValue ])
		ifTrue: [ ^ #() ].
	values := aProperty isMultivalued
		ifTrue: [ values := aValue asArray ]
		ifFalse: [ values := {aValue} ].
	^ values
		collect: [ :each | OPXMIValueAttribute xmiName: aProperty name value: each asString ]
]

{ #category : #writing }
OPUMLXMIWriter >> writeProperty: aProperty of: anElement [
	| accessor value |
	accessor := self accessorNameFor: aProperty.
	aProperty isDerived
		ifTrue: [ ^ #() ].
	value := anElement perform: accessor asSymbol.
	(value isNil or: [ value isCollection and: [ value isEmpty ] ])
		ifTrue: [ ^ #() ].
	(aProperty type oclIsKindOf: #PrimitiveType)
		ifTrue: [ ^ self writePrimitiveProperty: aProperty value: value of: anElement ].
	(aProperty type oclIsKindOf: #Enumeration)
		ifTrue: [ ^ self writeEnumerationProperty: aProperty value: value of: anElement ].
	(aProperty name = #type and: [ (anElement oclIsKindOf: #TypedElement) ])
		ifTrue: [ ^ self writeTypeProperty: aProperty value: value of: anElement ].
	aProperty isComposite
		ifFalse: [ ^ self writeNonCompositeProperty: aProperty value: value of: anElement ].
	self assert: [ aProperty isComposite ].
	aProperty name = 'metamodelReference'
		ifTrue: [ ^ self writeNonCompositeProperty: aProperty value: value of: anElement ].
	^ self writeCompositeProperty: aProperty value: value of: anElement
]

{ #category : #writing }
OPUMLXMIWriter >> writeTypeProperty: aProperty value: aValue of: anElement [
	self assert: [ aProperty name = #type ].
	(self isMetaclass: aValue)
		ifTrue: [ ^ {OPXMIReferenceElement new
				xmiName: aProperty name;
				xmiType: 'uml:' , aValue umlClassName;
				href: self metamodelUri , '#' , aValue name} ].
	^ self writeNonCompositeProperty: aProperty value: aValue of: anElement
]
