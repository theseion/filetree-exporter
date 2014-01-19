accessing
monticelloVersions
	| goferVersions versions  |
	"convert all gofer references/version into the real monticello versions"
	goferVersions := self versions.
	versions := Array new: goferVersions size.
	
	self stderr lf; flush.
	
	goferVersions withIndexDo: [ :each :index |
		self stderr startOfLine; clearToEnd; yellow; 
			<< 'Fetching Monticello All Versions: [';
			print: goferVersions size; << '/'; print: index; << ']';
			clear.
		versions at: index put: each version ].
	^ versions