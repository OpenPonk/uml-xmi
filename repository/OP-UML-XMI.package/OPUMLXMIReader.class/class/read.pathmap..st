instance creation
read: anXmlStream pathmap: aPathmap
	| xmi pathmap xmiResult |
	pathmap := aPathmap mapping copy.
	pathmap at: 'result' put: anXmlStream.
	xmiResult := OPXMIReader readFromMapping: pathmap.
	xmi := xmiResult at: 'result'.
	^ (self new readXmi: xmi) first