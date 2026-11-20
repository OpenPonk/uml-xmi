"
In-memory subclass of the XMI specifications storage used to verify local cache lookup, writing, and write-error resilience without network calls or touching the host filesystem.
"
Class {
	#name : 'OPUMLTestSpecsStorage',
	#superclass : 'OPUMLXMISpecsStorage',
	#instVars : [
		'specsDirectory',
		'retrievedContent',
		'shouldFailCaching',
		'retrieveCount'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Utility',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Utility'
}

{ #category : 'private' }
OPUMLTestSpecsStorage >> cacheLocally: aString forRelativePath: aRelativePath [

	self shouldFailCaching ifTrue: [ self error: 'Simulated read-only filesystem' ].
	super cacheLocally: aString forRelativePath: aRelativePath
]

{ #category : 'accessing' }
OPUMLTestSpecsStorage >> retrieveCount [

	^ retrieveCount ifNil: [ 0 ]
]

{ #category : 'retrieving' }
OPUMLTestSpecsStorage >> retrieveSpecsFor: aUrl [

	retrieveCount := self retrieveCount + 1.
	^ self retrievedContent
]

{ #category : 'accessing' }
OPUMLTestSpecsStorage >> retrievedContent [

	^ retrievedContent
]

{ #category : 'accessing' }
OPUMLTestSpecsStorage >> retrievedContent: aString [

	retrievedContent := aString
]

{ #category : 'accessing' }
OPUMLTestSpecsStorage >> shouldFailCaching [

	^ shouldFailCaching ifNil: [ false ]
]

{ #category : 'accessing' }
OPUMLTestSpecsStorage >> shouldFailCaching: aBoolean [

	shouldFailCaching := aBoolean
]

{ #category : 'accessing' }
OPUMLTestSpecsStorage >> specsDirectory [

	^ specsDirectory
]

{ #category : 'accessing' }
OPUMLTestSpecsStorage >> specsDirectory: aFileReference [

	specsDirectory := aFileReference
]
