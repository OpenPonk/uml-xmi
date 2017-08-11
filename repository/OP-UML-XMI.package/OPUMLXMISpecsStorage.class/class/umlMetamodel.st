accessing
umlMetamodel
	"
	UmlMetaModel := nil.
	"

	<script: 'self umlMetamodel inspect'>
	^ UmlMetaModel
		ifNil: [ | pathmap result |
			pathmap := OPUMLXMIPathmap new.
			pathmap add: 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi'.
			pathmap add: 'http://www.omg.org/spec/UML/20131001/UML.xmi'.
			result := OPXMIReader readFromMapping: pathmap mapping.
			UmlMetaModel := (OPUMLXMIReader new
				readXmi: (result at: 'http://www.omg.org/spec/UML/20131001/UML.xmi')) first ]