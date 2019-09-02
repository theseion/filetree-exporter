action-export
prepareLocalDestinationRepository
	| destinationFolder result fileTreeFolder |
	
	destinationFolder := self destinationFolder.

	destinationFolder exists ifFalse: [
		destinationFolder ensureCreateDirectory.
	
		result := OSProcess waitForCommand: 'cd "', destinationFolder fullName, '" && git init'.
		result succeeded ifFalse: [ 
			^ self exitFailure: 'Could not initialize empty git repository in ', destinationFolder fullName ] ].
	
	fileTreeFolder := destinationFolder / 'repository'.
	fileTreeFolder ensureCreateDirectory.
	
	^ MCFileTreeRepository new
		directory: fileTreeFolder;
		yourself