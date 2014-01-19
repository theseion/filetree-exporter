action
listPackages
	
	self printUniqueVersionInformation: [ :each | each packageName ].
	
	self exitSuccess.