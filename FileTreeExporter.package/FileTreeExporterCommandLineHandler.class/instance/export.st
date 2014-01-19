action-export
export
	| versions destination |
	"initialize the lazy user map"
	self userMap.
	destination := self prepareLocalDestinationRepository.
	versions := self monticelloVersions 
		asSortedCollection: self mcVersionDateComparisonBlock.
	versions withIndexDo: [ :version :index | 
		self printCommit: version from: index to: versions size.
		self exportVersion: version to: destination ].
	self halt.