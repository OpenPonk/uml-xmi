reading
groupedChildrenIn: anObjectElement
	^ ((anObjectElement containedItems
		reject: [ :each | #('xmi:' 'xmlns:') anySatisfy: [ :prefix | each xmiName beginsWith: prefix ] ])
		reject: [ :each | #('Extension' 'default' 'uri') includes: each xmiName ]) groupedBy: #xmiName