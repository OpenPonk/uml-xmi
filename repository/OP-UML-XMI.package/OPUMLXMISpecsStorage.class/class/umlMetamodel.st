accessing
umlMetamodel
	"
	UmlMetaModel := nil.
	"

	<script: 'self umlMetamodel inspect'>
	UmlMetaModel ifNil: [ self loadMetamodel ].
	^ UmlMetaModel