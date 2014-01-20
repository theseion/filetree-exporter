accessing
monticelloVersions
	"convert all gofer references/version into the real monticello versions"
	| goferVersions versions skip |
	skip := self versionSkip.
	goferVersions := self versions.
	versions := Array new: goferVersions size.
	
	goferVersions withIndexDo: [ :each :index |
		self
			printProgressMessage: 'Fetching All Monticello Versions:' 
			from: index
			to: goferVersions size.
		versions at: index put: each version ].
	self stderr lf.
	
	skip > 0
		ifTrue: [ 
			self inform: 'Skipping ', skip asString, ' out of ', versions size asString, ' versions'.
			^ versions allButFirst: skip ].
	^ versions