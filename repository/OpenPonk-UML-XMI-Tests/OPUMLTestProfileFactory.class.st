"
Lightweight profile factory test double used to verify URI-based profile resolution in XMI reader tests without depending on external profile packages.
"
Class {
	#name : 'OPUMLTestProfileFactory',
	#superclass : 'Object',
	#instVars : [
		'profile',
		'matchedURIs'
	],
	#category : 'OpenPonk-UML-XMI-Tests-Utility',
	#package : 'OpenPonk-UML-XMI-Tests',
	#tag : 'Utility'
}

{ #category : 'accessing' }
OPUMLTestProfileFactory >> matchedURIs [

	^ matchedURIs ifNil: [ #(  ) ]
]

{ #category : 'accessing' }
OPUMLTestProfileFactory >> matchedURIs: aCollection [

	matchedURIs := aCollection
]

{ #category : 'testing' }
OPUMLTestProfileFactory >> matchesURI: aUriString [

	^ (self profile isNotNil and: [ self profile URI = aUriString ]) or: [ self matchedURIs includes: aUriString ]
]

{ #category : 'accessing' }
OPUMLTestProfileFactory >> profile [

	^ profile
]

{ #category : 'accessing' }
OPUMLTestProfileFactory >> profile: aProfile [

	profile := aProfile
]
