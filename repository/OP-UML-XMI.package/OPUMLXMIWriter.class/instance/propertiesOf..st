accessing
propertiesOf: anElement
	| properties |
	properties := anElement umlMetaClass allAttributes asOrderedCollection.
	"throw away properties that were redefined by another one"
	properties copy
		do:
			[ :each | each redefinedProperties do: [ :redefined | properties remove: redefined ifAbsent: [  ] ] ].
	^ properties