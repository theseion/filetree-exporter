accessing
sourceUrl
	^ self 
		optionAt: 'from' 
		ifAbsent: [
			self exitFailure: 'Missing source repository [--from]' ]