# UML ↔ XMI Reader / Writer

[![Build Status](https://travis-ci.org/OpenPonk/uml-xmi.svg?branch=master)](https://travis-ci.org/OpenPonk/uml-xmi) [![Coverage Status](https://coveralls.io/repos/github/OpenPonk/uml-xmi/badge.svg?branch=master)](https://coveralls.io/github/OpenPonk/uml-xmi?branch=master)

Library for reading XMI files into UML models and vice versa.

For mapping from XML files to XMI graphs see [OpenPonk/xmi](https://github.com/OpenPonk/xmi).

For details on the used UML metamodel, see [OpenPonk/uml-metamodel](https://github.com/OpenPonk/uml-metamodel).

## Installation

```smalltalk
Metacello new
	baseline: 'OPUMLXMI';
	repository: 'github://OpenPonk/uml-xmi/repository';
	load.
```


## Basic Usage

### Reading

Reading a XML string/stream without any references.

```smalltalk
model := OPUMLXMIReader readFrom: aXmlStringStream.
```

Reading a XML string with a pathmap.

```smalltalk
pathmap := OPUMLXMIPathmap new.
pathmap add: 'http://www.omg.org/spec/UML/20131001/PrimitiveTypes.xmi'.
pathmap add: 'http://www.omg.org/spec/UML/20131001/UML.xmi' retrieveUsing: [ '/home/user/UML.xmi' asFileReference contents ].
model := OPUMLXMIReader readXmi: aXmlStringStream pathmap: pathmap.
```

### Writing

Writing a UML model into a XML string.

```smalltalk
OPUMLXMIWriter toString: aUmlModel.
```
