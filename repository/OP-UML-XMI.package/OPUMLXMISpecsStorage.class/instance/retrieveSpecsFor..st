actions
retrieveSpecsFor: aUrl
	| segments |
	segments := aUrl asZnUrl segments.
	"#(spec UML 20131001 PrimitiveTypes.xmi)"
	((segments beginsWith: #(spec UML)) or: [ segments beginsWith: #(spec DD) ])
		ifTrue:
			[ ^ (ZnEasy get: self baseUrl , 'UML/20131001/' , segments last) entity readStream contents ].
	self error: 'Urls like ' , aUrl , ' are not handled yet.'