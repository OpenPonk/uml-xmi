reading
readXmi: anXmi
	"
	anXmi containedItems collect: [ :each | self readItem: each property: nil ]
	"

	^ anXmi containedItems
		select: [ :each | each isObjectElement and: [ #(Model Package Profile) includes: each xmiName ] ]
		thenCollect: [ :each | self readItem: each property: nil ]