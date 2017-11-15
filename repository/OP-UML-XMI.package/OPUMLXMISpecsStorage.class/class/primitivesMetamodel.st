accessing
primitivesMetamodel
	"
	PrimitivesMetaModel := nil.
	"

	<script: 'self primitivesMetamodel inspect'>
	PrimitivesMetaModel ifNil: [ self loadMetamodel ].
	^ PrimitivesMetaModel