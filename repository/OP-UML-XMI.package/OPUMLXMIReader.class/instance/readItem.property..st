reading
readItem: anItem property: aProperty
	| instance groups |
	anItem isValueItem
		ifTrue: [ ^ self valueFor: anItem value ].
	anItem isReferenceItem
		ifTrue: [ (anItem href isNotNil and: [anItem href beginsWith: 'http://www.omg.org/spec/UML/'])
				ifTrue: [ ^ self readMetamodelItem: anItem property: aProperty ].
			^ anItem referencedElements
				collect: [ :each | self readItem: each property: aProperty ] ].
	instanceCache at: (self uniqueIdOf: anItem) ifPresent: [ :match | ^ match ].
	instance := self instanceFor: anItem property: aProperty.
	groups := self groupedChildrenIn: anItem.
	groups
		keysAndValuesDo: [ :key :values | 
			| selector arguments pluralSelector sg pl isMultivalued property |
			property := (instance umlMetaClass allAttributes select: [ :each | each name = key ])
				last.
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
			arguments := values collect: [ :each | self readItem: each property: property ].
			(arguments anyOne isArray or: [ arguments anyOne isKindOf: OrderedCollection ])
				ifTrue: [ arguments := arguments gather: #yourself ].
			isMultivalued
				ifTrue: [ instance perform: selector with: arguments ]
				ifFalse: [ self assert: [ values size = 1 ].
					self flag: 'Because unresolved references...'.
					arguments size > 0
						ifTrue: [ instance perform: selector with: arguments first ] ] ].
	^ instance