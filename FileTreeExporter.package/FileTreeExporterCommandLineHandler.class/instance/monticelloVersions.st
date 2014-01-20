accessing
monticelloVersions
	| goferVersions versions  |
	"convert all gofer references/version into the real monticello versions"
	goferVersions := self versions.
	versions := Array new: goferVersions size.
	goferVersions withIndexDo: [ :each :index |
		self
			printProgressMessage: 'Fetching Monticello All Versions:' 
			from: index
			to: goferVersions size.
		versions at: index put: each version ].
	self stderr lf.
	^ versions