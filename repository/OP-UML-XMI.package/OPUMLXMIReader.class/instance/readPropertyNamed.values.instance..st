reading
readPropertyNamed: aKey values: values instance: anInstance
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