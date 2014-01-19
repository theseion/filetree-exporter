action-export
gitUserFromMCUser: mcAuthorString
	^ self userMap 
		at: mcAuthorString
		ifAbsent: [ 
			self inform: 'Missing Git Author! Using "', mcAuthorString,' <>" instead'.
			mcAuthorString, ' <>' ]