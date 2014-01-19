accessing
sourceUrl
	^ self optionAt: 'from' ifAbsent: [ self error: 'Missing source repository [--from]' ]