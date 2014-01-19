action-export
export
	| versions destination |
	"initialize the lazy user map"
	self userMap.
	destination := self prepareLocalDestinationRepository.
	versions := self monticelloVersions 
		asSortedCollection: self mcVersionDateComparisonBlock.
	self halt.
	versions withIndexDo: [ :version :index | 
		self
			printProgressMessage: ('Exporting ', version info name)
			from: index
			to: versions size.
		self exportVersion: version to: destination ].