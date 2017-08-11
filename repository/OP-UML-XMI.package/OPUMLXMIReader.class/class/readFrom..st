instance creation
readFrom: aStream
	^ (self new readXmi: (OPXMIReader readFrom: aStream)) first