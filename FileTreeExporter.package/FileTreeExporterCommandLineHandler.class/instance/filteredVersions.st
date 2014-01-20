accessing
filteredVersions
	| versions regex |
	
	versions := self versions.
	regex := self optionAt: 'package-filter' ifAbsent: [ ^ versions ].
	[ regex := regex asRegex ]
		on: Error do: [
			self exitFailure: 'Could not parse package-regex: "', regex.'"' ].
	^ versions select: [ :each | regex search: each packageName ]