accessing
metaClassFor: anElement
	MetaClassMap
		ifNil: [ MetaClassMap := ((self umlMetamodel packagedElements flatCollect: #packagedElements)
				select: [ :each | each umlClassName = #Class ]
				thenCollect: [ :each | each name -> each ]) asDictionary ].
	^ MetaClassMap at: anElement umlClassName