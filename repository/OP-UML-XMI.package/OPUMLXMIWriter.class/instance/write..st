writing
write: anElement
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