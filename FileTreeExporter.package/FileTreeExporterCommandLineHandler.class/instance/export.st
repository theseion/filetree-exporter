action-export
export
	| userMap versions |
	userMap := self userMap.
	versions := self monticelloVersions 
		asSortedCollection: self mcVersionDateComparisonBlock.