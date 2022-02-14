Class {
	#name : #OPUMLXMIReader,
	#superclass : #Object,
	#instVars : [
		'classPrefix',
		'instanceCache'
	],
	#category : #'OP-UML-XMI-Reader'
}

{ #category : #'instance creation' }
OPUMLXMIReader class >> read: anXmlStream [
	^ self read: anXmlStream pathmap: OPUMLXMIPathmap default
]

{ #category : #'instance creation' }
OPUMLXMIReader class >> read: anXmlStream pathmap: aPathmap [
	| xmi pathmap xmiResult processedXmi |
	pathmap := aPathmap mapping copy.
	pathmap at: 'result' put: anXmlStream contents.
	xmiResult := OPXMIReader readFromMapping: pathmap.
	xmi := xmiResult at: 'result'.
	processedXmi := self new readXmi: xmi.
	^ processedXmi first
]

{ #category : #'instance creation' }
OPUMLXMIReader class >> readFrom: aStream [
	^ (self new readXmi: (OPXMIReader readFrom: aStream)) first
]

{ #category : #'as yet unclassified' }
OPUMLXMIReader >> applyStereotype: anStereotypeXMI outOf: possibleStereotypes to: anElement [
	| stereotype groups |
	stereotype := (possibleStereotypes at: anStereotypeXMI xmiName)
		implementationClass new.
	anElement applyStereotype: stereotype.
	"anStereotypeXMI containedItems reject: [ :each | each name beginsWith: 'base_' ] thenDo: [:each | stereotype perform: (each xmiName , ':') asSymbol with: each value ]."
	groups := self groupedChildrenIn: anStereotypeXMI.
	(groups
		associationsSelect: [ :each | (each key beginsWith: 'base_') not ])
		keysAndValuesDo:
			[ :key :values | self readPropertyNamed: key values: values instance: stereotype ]
]

{ #category : #reading }
OPUMLXMIReader >> applyStereotypesAmongst: elements to: models [
	| possibleStereotypes |
	possibleStereotypes := ((models
		flatCollect: [ :each | 
			(each profileApplications collect: #appliedProfile)
				flatCollect: [ :eachProfile | eachProfile ownedStereotype ] ])
		collect: [ :each | each name -> each ]) asDictionary.
	elements
		select: [ :each | 
			(possibleStereotypes includesKey: each xmiName)
				and: [ each containedItems
						anySatisfy: [ :any | any xmiName beginsWith: 'base_' ] ] ]
		thenDo: [ :each | 
			self
				applyStereotype: each
				outOf: possibleStereotypes
				to:
					(instanceCache
						at:
							(each containedItems
								detect: [ :any | any xmiName beginsWith: 'base_' ])
								referencedElement xmiId) ]
]

{ #category : #converting }
OPUMLXMIReader >> asPlural: aString [
	(aString endsWith: 's')
		ifTrue: [ ^ aString , 'es' ].
	(aString endsWith: 'y')
		ifTrue: [ ^ (aString withoutSuffix: 'y') , 'ies' ].
	^ aString , 's'
]

{ #category : #accessing }
OPUMLXMIReader >> classPrefix [
	^ classPrefix
]

{ #category : #accessing }
OPUMLXMIReader >> classPrefix: anObject [
	classPrefix := anObject
]

{ #category : #'instance creation' }
OPUMLXMIReader >> createNewInstanceFor: anItem property: aProperty [
	| name |
	name := aProperty
		ifNil: [ "Root elements only"
			self assert: [ #(Package Model Profile) includes: anItem xmiName ].
			anItem xmiName ]
		ifNotNil: [ anItem xmiType
				ifNil: [ aProperty type name ]
				ifNotNil: [ :type | (type splitOn: ':') last ] ].
	^ (self classPrefix , name) asSymbol asClass new
		uuid:
			([ UUID fromString: anItem xmiId ]
				on: Error
				do: [ anItem xmiId ]);
		yourself
]

{ #category : #accessing }
OPUMLXMIReader >> defaultClassPrefix [
	^ 'OPUML'
]

{ #category : #reading }
OPUMLXMIReader >> groupedChildrenIn: anObjectElement [
	^ ((anObjectElement containedItems
		reject: [ :each | #('xmi:' 'xmlns:') anySatisfy: [ :prefix | each xmiName beginsWith: prefix ] ])
		reject: [ :each | #('Extension' 'default' 'uri') includes: each xmiName ]) groupedBy: #xmiName
]

{ #category : #initialization }
OPUMLXMIReader >> initialize [
	super initialize.
	instanceCache := Dictionary new.
	classPrefix := self defaultClassPrefix
]

{ #category : #'instance creation' }
OPUMLXMIReader >> instanceFor: anObjectElement property: aProperty [
	^ instanceCache
		at: (self uniqueIdOf: anObjectElement)
		ifAbsentPut: [ self createNewInstanceFor: anObjectElement property: aProperty ]
]

{ #category : #reading }
OPUMLXMIReader >> readItem: anItem property: aProperty [
	| instance groups |
	anItem isValueItem
		ifTrue: [ ^ self valueFor: anItem value property: aProperty ].
		
	anItem isReferenceItem
		ifTrue: [ aProperty name = 'appliedProfile'
				ifTrue: [ ^ self readProfileItem: anItem property: aProperty ].
				
			(anItem href isNotNil
				and: [ anItem href beginsWith: 'http://www.omg.org/spec/UML/' ])
				ifTrue: [ ^ self readMetamodelItem: anItem property: aProperty ].
			(anItem href isNotNil
				and: [ anItem href beginsWith: 'http://schema.omg.org/spec/MOF/' ])
				ifTrue: [ ^ self readMofItem: anItem property: aProperty ].
			^ anItem referencedElements
				collect: [ :each | self readItem: each property: aProperty ] ].
	instanceCache
		at: (self uniqueIdOf: anItem)
		ifPresent: [ :match | ^ match ].
	instance := self instanceFor: anItem property: aProperty.
	groups := self groupedChildrenIn: anItem.
	groups
		keysAndValuesDo:
			[ :key :values | self readPropertyNamed: key values: values instance: instance ].
	^ instance
]

{ #category : #reading }
OPUMLXMIReader >> readMetamodelItem: anItem property: aProperty [
	| parts |
	parts := anItem href splitOn: '#'.
	(parts first endsWith: 'PrimitiveTypes.xmi')
		ifTrue: [ ^ OPUMLXMISpecsStorage primitiveTypeNamed: parts second ].
	(parts first endsWith: 'UML.xmi')
		ifTrue: [ ^ OPUMLXMISpecsStorage metaClassNamed: parts second ].
	self error: 'Unknown type at ' , anItem href
]

{ #category : #reading }
OPUMLXMIReader >> readMofItem: anItem property: aProperty [
	| parts |
	parts := anItem href splitOn: '#'.
	^ OPUMLXMISpecsStorage primitiveTypeNamed: parts second
]

{ #category : #reading }
OPUMLXMIReader >> readProfileItem: anItem property: aProperty [
	| parts factory |
	parts := anItem href splitOn: '#'.
	self class environment
		at: #OPUmlCustomProfile
		ifPresent: [ :cls | 
			factory := cls allSubclasses
				detect: [ :each | each profile URI = parts first ]
				ifNone: [ self error: 'No profile with URI ' , parts first , ' found' ] ]
		ifAbsent: [  ].
	^ factory profile
]

{ #category : #reading }
OPUMLXMIReader >> readPropertyNamed: aKey values: values instance: anInstance [
	| property pluralSelector isMultivalued sg arguments pl selector |
	property := (anInstance umlMetaClass allAttributes select: [ :each | each name = aKey ])
		last.
	selector := (aKey , ':') asSymbol.
	pluralSelector := ((self asPlural: aKey) , ':') asSymbol.
	sg := (anInstance class selectors includes: selector)
		or: [ anInstance class superclass name = (self classPrefix , 'Element')
				and: [ anInstance class superclass selectors includes: selector ] ].
	pl := (anInstance class selectors includes: pluralSelector)
		or: [ anInstance class superclass name = (self classPrefix , 'Element')
				and: [ anInstance class superclass selectors includes: pluralSelector ] ].
	isMultivalued := sg not & pl.
	isMultivalued
		ifTrue: [ selector := pluralSelector ].
	self assert: [ sg | pl ].
	arguments := values collect: [ :each | self readItem: each property: property ].
	(arguments anyOne isArray or: [ arguments anyOne isKindOf: OrderedCollection ])
		ifTrue: [ arguments := arguments gather: #yourself ].
	^ isMultivalued
		ifTrue: [ anInstance perform: selector with: arguments ]
		ifFalse: [ self assert: [ values size = 1 ].
			self flag: 'Because unresolved references...'.
			arguments size > 0
				ifTrue: [ anInstance perform: selector with: arguments first ] ]
]

{ #category : #reading }
OPUMLXMIReader >> readXmi: anXmi [
	| elements models |
	(anXmi isObjectElement
		and: [ #(Model Package Profile) includes: anXmi xmiName ])
		ifTrue: [ ^ self readItem: anXmi property: nil ].
	elements := anXmi containedItems
		select: [ :each | each isObjectElement ].
	models := elements
		select: [ :each | #(Model Package Profile) includes: each xmiName ]
		thenCollect: [ :each | self readItem: each property: nil ].
	self applyStereotypesAmongst: elements to: models.
	^ models
]

{ #category : #reading }
OPUMLXMIReader >> uniqueIdOf: anObject [
	anObject xmiName = 'packageImport'
		ifTrue: [ ^ anObject xmiId , '-'
				, (anObject containedItems detect: [ :each | each xmiName = #importedPackage ]) referencedElement xmiId ].
	^ anObject xmiId
]

{ #category : #reading }
OPUMLXMIReader >> valueFor: anObject property: aProperty [
	(#('Integer') includes: aProperty type name)
		ifTrue: [ ^ Number readFromString: anObject ].
	aProperty type name = 'UnlimitedNatural'
		ifTrue: [ anObject = '*'
				ifTrue: [ ^ anObject ].
			^ Number readFromString: anObject ].
	aProperty type name = 'String'
		ifTrue: [ ^ anObject asString ].
	aProperty type name = 'Boolean'
		ifTrue: [ self
				assert: [ #('true' 'false') includes: anObject ]
				description: 'Unexpected type'.
			^ anObject = 'true' ].
	(aProperty type oclIsKindOf: #Enumeration)
		ifTrue: [ ^ anObject asSymbol ].
	self error: 'Guessed type.'.
	(NumberParser isNumber: anObject)
		ifTrue: [ ^ Number readFromString: anObject ].
	^ anObject
]
