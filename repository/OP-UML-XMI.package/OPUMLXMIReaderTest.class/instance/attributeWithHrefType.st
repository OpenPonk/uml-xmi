instance creation
attributeWithHrefType
	^ OPXMIReader
		readFrom:
			'<ownedAttribute xmi:type="uml:Property" xmi:id="Formal-base_Association" name="base_Association">
	<type xmi:type="uml:Class" href="http://www.omg.org/spec/UML/20131001/UML.xmi#Association" />
</ownedAttribute>'