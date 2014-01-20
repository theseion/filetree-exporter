action-export
export
	| versions destination |
	"initialize the lazy user map"
	self userMap.
	destination := self prepareLocalDestinationRepository.
	versions := self monticelloVersions 
		asSortedCollection: self mcVersionDateComparisonBlock.
		
	versions withIndexDo: [ :version :index | 
		self
			printProgressMessage: ('Exporting ', version info name)
			from: index + self versionSkip
			to: versions size + self versionSkip.	
		self stderr lf.
		self exportVersion: version to: destination ].
	
	self exitSuccess.
