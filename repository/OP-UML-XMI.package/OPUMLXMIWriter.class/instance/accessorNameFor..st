writing
accessorNameFor: aProperty
	| name |
	name := aProperty name.
	name = 'class'
		ifTrue: [ name := 'owningClass' ].
	aProperty isMultivalued
		ifTrue: [ ^ self asPlural: name ].
	^ name