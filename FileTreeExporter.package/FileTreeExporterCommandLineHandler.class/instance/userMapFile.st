accessing
userMapFile
	^ (self
		optionAt: 'user-map'
		ifAbsent: [ 
			self exitFailure: 'Missing Option --user-map' ]) asFileReference