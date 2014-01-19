action-export
export
	| userMap versions destination |
	userMap := self userMap.
	self inform: 'Fetching '.
	versions := self monticelloVersions 
		asSortedCollection: self mcVersionDateComparisonBlock.
	destination := self prepareLocalDestinationRepository.
	self halt.