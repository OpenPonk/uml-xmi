Class {
	#name : 'OPUMLXMISpecsStorage',
	#superclass : 'Object',
	#instVars : [
		'storage'
	],
	#classVars : [
		'Current',
		'MetaClassMap',
		'PrimitivesMap',
		'PrimitivesMetaModel',
		'UmlMetaModel'
	],
	#category : 'OP-UML-XMI-Utility',
	#package : 'OP-UML-XMI',
	#tag : 'Utility'
}

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> current [
	"
	Current := nil
	"
	^ Current ifNil: [ Current := self new ]
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> loadMetamodel [
	"
	UmlMetaModel := nil.
	PrimitivesMetaModel := nil.
	"

	<script: 'self loadMetamodel inspect'>
	| pathmap result packages xmiDom models |
	pathmap := OPUMLXMIPathmap new.
	pathmap add: 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi'.
	pathmap add: 'http://www.omg.org/spec/UML/20131001/UML.xmi'.
	result := OPXMIReader readFromMapping: pathmap mapping.
	packages := result values
		flatCollect: [ :xmi | 
			xmi containedItems
				select: [ :each | each isObjectElement and: [ each xmiName = 'Package' ] ] ].
	(packages first containedItems
		detect: [ :each | each isValueAttribute and: [ each xmiName = 'xmi:id' ] ]) value: '_1'.
	xmiDom := OPXMIObjectElement new containedItems: packages.
	models := OPUMLXMIMetaReader new readXmi: xmiDom.
	PrimitivesMetaModel := models first.
	UmlMetaModel := models second.
	^ {PrimitivesMetaModel.
	UmlMetaModel}
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> metaClassFor: anElement [
	^ self metaClassNamed: anElement umlClassName
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> metaClassMap [
	"
	MetaClassMap := nil
	"

	^ MetaClassMap
		ifNil: [ MetaClassMap := ((self umlMetamodel packagedElements flatCollect: #packagedElements)
				select: [ :each | each umlClassName = #Class ]
				thenCollect: [ :each | each name -> each ]) asDictionary ]
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> metaClassNamed: aClassName [
	^ self metaClassMap at: aClassName
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> primitiveTypeNamed: aPrimitiveName [
	^ self primitivesMap at: aPrimitiveName
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> primitivesMap [
	"
	PrimitivesMap := nil
	"

	^ PrimitivesMap
		ifNil: [ PrimitivesMap := (self primitivesMetamodel packagedElements
				collect: [ :each | each name -> each ]) asDictionary ]
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> primitivesMetamodel [
	"
	PrimitivesMetaModel := nil.
	"

	<script: 'self primitivesMetamodel inspect'>
	PrimitivesMetaModel ifNil: [ self loadMetamodel ].
	^ PrimitivesMetaModel
]

{ #category : 'actions' }
OPUMLXMISpecsStorage class >> reset [

	<script>
	Current := nil.
	MetaClassMap := nil.
	PrimitivesMap := nil.
	PrimitivesMetaModel := nil.
	UmlMetaModel := nil
]

{ #category : 'actions' }
OPUMLXMISpecsStorage class >> resetCurrent [
	<script>
	Current := nil
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage class >> umlMetamodel [
	"
	UmlMetaModel := nil.
	"

	<script: 'self umlMetamodel inspect'>
	UmlMetaModel ifNil: [ self loadMetamodel ].
	^ UmlMetaModel
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage >> at: aUrl [
	^ storage at: aUrl ifAbsentPut: [ self retrieveSpecsFor: aUrl ]
]

{ #category : 'accessing' }
OPUMLXMISpecsStorage >> baseUrl [
	^ 'https://raw.githubusercontent.com/OpenPonk/specs-repository/master/'
]

{ #category : 'initialization' }
OPUMLXMISpecsStorage >> initialize [
	super initialize.
	storage := Dictionary new
]

{ #category : 'actions' }
OPUMLXMISpecsStorage >> retrieveSpecsFor: aUrl [

	| segments specs |
	segments := aUrl asZnUrl segments.
	(segments beginsWithAnyOf: #( #( spec UML ) #( spec DD ) )) ifFalse: [ 
		^ self error: 'Urls like ' , aUrl , ' are not handled yet.' ].
	specs := [ :job | 
	         | response |
	         job title: 'Downloading specs from ' , self baseUrl.
	         response := ZnEasy get:
		                     self baseUrl , 'UML/20131001/' , segments last.
	         job currentValue: 50.
	         response entity readStream contents ] asJob run.

	^ [ :bar | 
	  bar title: 'Downloading specs from ' , self baseUrl.
	  [ 
	  ZnClient new
		  url: self baseUrl , 'UML/20131001/' , segments last;
		  signalProgress: true;
		  get ]
		  on: HTTPProgress
		  do: [ :progress | 
			  progress isEmpty ifFalse: [ bar current: progress percentage ].
			  progress resume ] ] asJob run
]
