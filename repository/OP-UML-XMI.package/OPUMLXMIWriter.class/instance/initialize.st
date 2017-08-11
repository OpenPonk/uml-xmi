initialization
initialize
	super initialize.
	identityCache := Dictionary new.
	classPrefix := self defaultClassPrefix