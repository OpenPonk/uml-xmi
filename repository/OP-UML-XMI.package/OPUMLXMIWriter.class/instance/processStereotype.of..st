writing
processStereotype: aStereotype of: anElement
	| element containedItems properties |
	element := OPXMIObjectElement new.
	containedItems := OrderedCollection new.
	element containedItems: containedItems.
	element xmiName: aStereotype profile name , ':' , aStereotype name.
	containedItems
		add: (OPXMIValueAttribute xmiName: 'xmi:id' value: (self idFor: aStereotype)).
	properties := aStereotype ownedAttributes asArray.
	properties := (properties collect: [ :each | each name -> each ]) asOrderedDictionary
		values.
	properties
		do: [ :each | containedItems addAll: (self writeStereotypeProperty: each of: aStereotype) ].
	stereotypes add: element