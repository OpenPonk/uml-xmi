writing
processStereotypesIn: anElement
	anElement appliedStereotypes ifEmpty: [ ^ self ].
	anElement appliedStereotypes
		do: [ :stereo | self processStereotype: stereo of: anElement ]