Class {
	#name : #OPUMLXMIMetaReader,
	#superclass : #OPUMLXMIReader,
	#category : 'OP-UML-XMI-Reader'
}

{ #category : #'instance creation' }
OPUMLXMIMetaReader >> createNewInstanceFor: anItem property: aProperty [
	| name |
	name := (#(Package Model Profile) includes: anItem xmiName)
		ifTrue: [ anItem xmiName ]
		ifFalse: [ anItem xmiType
				ifNil: [ self error: 'Unknown element type.' ]
				ifNotNil: [ :type | (type splitOn: ':') last ] ].
	^ (self classPrefix , name) asSymbol asClass new
]

{ #category : #reading }
OPUMLXMIMetaReader >> readItem: anItem property: aProperty [
	| instance groups |
	anItem isValueItem
		ifTrue: [ ^ self valueFor: anItem value ].
	anItem isReferenceItem
		ifTrue: [ ^ anItem referencedElements
				collect: [ :each | self readItem: each property: nil ] ].
	instanceCache at: (self uniqueIdOf: anItem) ifPresent: [ :match | ^ match ].
	instance := self instanceFor: anItem property: nil.
	groups := self groupedChildrenIn: anItem.
	groups
		keysAndValuesDo: [ :key :values | 
			| selector arguments pluralSelector sg pl isMultivalued |
			selector := (key , ':') asSymbol.
			pluralSelector := ((self asPlural: key) , ':') asSymbol.
			sg := (instance class selectors includes: selector)
				or: [ instance class superclass name = (self classPrefix , 'Element')
						and: [ instance class superclass selectors includes: selector ] ].
			pl := (instance class selectors includes: pluralSelector)
				or: [ instance class superclass name = (self classPrefix , 'Element')
						and: [ instance class superclass selectors includes: pluralSelector ] ].
			isMultivalued := sg not & pl.
			isMultivalued
				ifTrue: [ selector := pluralSelector ].
			self assert: [ sg | pl ].
			arguments := values collect: [ :each | self readItem: each property: nil ].
			(arguments anyOne isArray or: [ arguments anyOne isKindOf: OrderedCollection ])
				ifTrue: [ arguments := arguments gather: #yourself ].
			isMultivalued
				ifTrue: [ instance perform: selector with: arguments ]
				ifFalse: [ self assert: [ values size = 1 ].
					self flag: 'Because unresolved references...'.
					arguments size > 0
						ifTrue: [ instance perform: selector with: arguments first ] ] ].
	^ instance
]

{ #category : #reading }
OPUMLXMIMetaReader >> valueFor: anObject [
	anObject = 'true'
		ifTrue: [ ^ true ].
	anObject = 'false'
		ifTrue: [ ^ false ].
	(NumberParser isNumber: anObject)
		ifTrue: [ ^ Number readFromString: anObject ].
	^ anObject
]
