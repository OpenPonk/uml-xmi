reading
readXmi: anXmi
	^ anXmi containedItems
		select: [ :each | 
			each isObjectElement
				and: [ (each xmiType isNotNil and: [ each xmiType beginsWith: 'uml:' ])
						and: [ #(Model Package Profile) includes: each xmiName ] ] ]
		thenCollect: [ :each | self readItem: each ]