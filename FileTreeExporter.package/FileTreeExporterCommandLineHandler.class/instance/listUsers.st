action
listUsers
	self printUniqueVersionInformation: [ :each | each author ].
	self exitSuccess.