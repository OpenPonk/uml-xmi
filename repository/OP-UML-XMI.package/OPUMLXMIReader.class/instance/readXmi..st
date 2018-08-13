reading
readXmi: anXmi
	"
	anXmi containedItems collect: [ :each | self readItem: each property: nil ]
	"

	(anXmi isObjectElement and: [ #(Model Package Profile) includes: anXmi xmiName ])
		ifTrue: [ ^ self readItem: anXmi property: nil ].
	^ anXmi containedItems
		select: [ :each | each isObjectElement and: [ #(Model Package Profile) includes: each xmiName ] ]
		thenCollect: [ :each | self readItem: each property: nil ]