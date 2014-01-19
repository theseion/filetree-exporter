action-listing
listPackages
	
	self printUniqueVersionInformation: [ :each | each packageName ].
	
	self exitSuccess.