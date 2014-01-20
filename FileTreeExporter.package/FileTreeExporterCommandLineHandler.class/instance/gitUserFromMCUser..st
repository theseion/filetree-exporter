action-export
gitUserFromMCUser: mcAuthorString
	^ self userMap 
		at: mcAuthorString
		ifAbsent: [ 
			self inform: 'Missing Git Author! Using "', mcAuthorString,' <no@email.com>" instead'.
			mcAuthorString, ' <no@email.com>' ]