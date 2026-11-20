"
Unit tests verifying OMG UML specification URL mapping, local caching, singleton lifecycle resets, and metamodel lookup behavior.
"
Class {
	#name : 'OPUMLXMISpecsStorageTest',
	#superclass : 'TestCase',
	#instVars : [
		'storage',
		'memoryDirectory'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Utility',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Utility'
}

{ #category : 'running' }
OPUMLXMISpecsStorageTest >> setUp [

	super setUp.
	memoryDirectory := FileSystem memory root / 'specs'.
	storage := OPUMLTestSpecsStorage new
		           specsDirectory: memoryDirectory;
		           yourself
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testAtRetrievesAndCachesOnCacheMiss [

	| result cachedFile |
	storage retrievedContent: 'downloaded-content'.
	result := storage at: 'http://www.omg.org/spec/UML/20131001/Remote.xmi'.
	self assert: result equals: 'downloaded-content'.
	self assert: storage retrieveCount equals: 1.
	cachedFile := memoryDirectory resolve: 'UML/20131001/Remote.xmi'.
	self assert: cachedFile exists description: 'Retrieved spec must be written to local cache'.
	self assert: cachedFile contents equals: 'downloaded-content'
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testAtReturnsRetrievedContentWhenCachingFails [

	| result |
	storage
		retrievedContent: 'fallback-content';
		shouldFailCaching: true.
	result := storage at: 'http://www.omg.org/spec/UML/20131001/ReadOnly.xmi'.
	self assert: result equals: 'fallback-content'.
	self assert: storage retrieveCount equals: 1
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testAtUsesLocalCacheWhenPresent [

	| cachedFile result |
	cachedFile := memoryDirectory resolve: 'UML/20131001/Cached.xmi'.
	cachedFile parent ensureCreateDirectory.
	cachedFile writeStreamDo: [ :stream | stream nextPutAll: 'cached-content' ].
	storage retrievedContent: 'remote-content'.

	result := storage at: 'http://www.omg.org/spec/UML/20131001/Cached.xmi'.
	self assert: result equals: 'cached-content'.
	self assert: storage retrieveCount equals: 0
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testBaseUrl [

	self assert: storage baseUrl equals: 'https://raw.githubusercontent.com/OpenPonk/specs-repository/master/'
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testCacheLocallyWritesFileInSpecsDirectory [

	| cachedFile |
	storage cacheLocally: '<xmi/>' forRelativePath: 'UML/20131001/Test.xmi'.
	cachedFile := memoryDirectory resolve: 'UML/20131001/Test.xmi'.
	self assert: cachedFile exists description: 'Cached spec file must be created in specsDirectory'.
	self assert: cachedFile contents equals: '<xmi/>'
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testRelativePathForDdUrl [

	self assert: (storage relativePathForUrl: 'http://www.omg.org/spec/DD/20131001/DI.xmi') equals: 'DD/20131001/DI.xmi'
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testRelativePathForUmlUrl [

	self assert: (storage relativePathForUrl: 'http://www.omg.org/spec/UML/20131001/UML.xmi') equals: 'UML/20131001/UML.xmi'
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testRelativePathForUnsupportedUrlRaisesError [

	self
		should: [ storage relativePathForUrl: 'http://www.example.com/other/Spec.xmi' ]
		raise: Error
		withExceptionDo: [ :error |
		self assert: error messageText equals: 'Urls like http://www.example.com/other/Spec.xmi are not handled yet.' ]
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testResetAndReloadMetamodelAndMetaClassLookup [

	| savedCurrent savedMetaClassMap savedPrimitivesMap savedPrimitivesMetaModel savedUmlMetaModel umlClassMeta |
	savedCurrent := OPUMLXMISpecsStorage classVarNamed: #Current.
	savedMetaClassMap := OPUMLXMISpecsStorage classVarNamed: #MetaClassMap.
	savedPrimitivesMap := OPUMLXMISpecsStorage classVarNamed: #PrimitivesMap.
	savedPrimitivesMetaModel := OPUMLXMISpecsStorage classVarNamed: #PrimitivesMetaModel.
	savedUmlMetaModel := OPUMLXMISpecsStorage classVarNamed: #UmlMetaModel.
	[
		OPUMLXMISpecsStorage reset.
		self assert: OPUMLXMISpecsStorage current class identicalTo: OPUMLXMISpecsStorage.
		self assert: OPUMLXMISpecsStorage primitivesMetamodel name equals: 'PrimitiveTypes'.
		self assert: (OPUMLXMISpecsStorage primitiveTypeNamed: 'Boolean') name equals: 'Boolean'.

		OPUMLXMISpecsStorage reset.
		self assert: OPUMLXMISpecsStorage umlMetamodel name equals: 'UML'.
		umlClassMeta := OPUMLXMISpecsStorage metaClassNamed: 'Class'.
		self assert: umlClassMeta name equals: 'Class'.
		self assert: (OPUMLXMISpecsStorage metaClassFor: OPUMLClass new) identicalTo: umlClassMeta.
		self assert: OPUMLClass new umlMetaClass identicalTo: umlClassMeta ] ensure: [
			OPUMLXMISpecsStorage classVarNamed: #Current put: savedCurrent.
			OPUMLXMISpecsStorage classVarNamed: #MetaClassMap put: savedMetaClassMap.
			OPUMLXMISpecsStorage classVarNamed: #PrimitivesMap put: savedPrimitivesMap.
			OPUMLXMISpecsStorage classVarNamed: #PrimitivesMetaModel put: savedPrimitivesMetaModel.
			OPUMLXMISpecsStorage classVarNamed: #UmlMetaModel put: savedUmlMetaModel ]
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testSpecsDirectoryPointsToImageSpecsFolder [

	self assert: OPUMLXMISpecsStorage new specsDirectory equals: FileLocator imageDirectory / 'specs'
]

{ #category : 'tests' }
OPUMLXMISpecsStorageTest >> testSpecsLocalDirectoryReturnsNilWhenMissing [

	self assert: storage specsLocalDirectory identicalTo: nil.
	memoryDirectory ensureCreateDirectory.
	self assert: storage specsLocalDirectory equals: memoryDirectory
]
