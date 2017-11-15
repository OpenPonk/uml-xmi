writing
writeElement: anElement
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