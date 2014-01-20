action-listing
listUsers
	self printUniqueVersionInformation: [ :each | each author ].
	self exitSuccess.