writing
processStereotype: aStereotype of: anElement
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