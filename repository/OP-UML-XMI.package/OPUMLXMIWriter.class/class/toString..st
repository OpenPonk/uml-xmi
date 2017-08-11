instance creation
toString: aModel
	^ OPXMIWriter writeToString: (self new write: aModel)