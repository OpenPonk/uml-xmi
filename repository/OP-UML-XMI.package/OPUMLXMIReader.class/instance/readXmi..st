reading
readXmi: anXmi
	^ anXmi containedItems
		select: [ :each | 
			each isObjectElement
				and: [ (each xmiType isNotNil and: [ each xmiType beginsWith: 'uml:' ])
						and: [ each xmiName = 'Model' | (each xmiName = 'Package') ] ] ]
		thenCollect: [ :each | self readItem: each ]