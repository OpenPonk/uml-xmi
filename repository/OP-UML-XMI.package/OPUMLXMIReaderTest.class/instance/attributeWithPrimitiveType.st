instance creation
attributeWithPrimitiveType
	^ OPXMIReader
		readFrom:
			'<ownedAttribute xmi:type="uml:Property" xmi:id="-attribute" name="attribute">
   <type xmi:type="uml:PrimitiveType" href="http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi#Boolean" />
</ownedAttribute>'